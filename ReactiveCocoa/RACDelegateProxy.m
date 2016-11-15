#import "RACDelegateProxy.h"
#import <ReactiveCocoa/RACObjCRuntimeUtilities.h>
#import <objc/message.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
@implementation RACDelegateProxy

	Protocol* proxyingProtocol;
	NSSet* optionalSelectors;
	NSSet* optionalReturningSelectors;
	NSDictionary<NSValue *, NSMethodSignature *>* methodSignatures;
	void (*originalSetterIMP)(id, SEL, id _Nullable);
	SEL originalSetterSelector;
	__weak id delegater;

-(instancetype)initWithProtocol:(Protocol *)protocol forObject:(nonnull id)object originalSetterSelector:(SEL)selector IMP:(void (*)(id, SEL, id _Nullable))implementation {
	self = [super init];

	if (self) {
		NSString *className = [[@"_" stringByAppendingString:NSStringFromProtocol(protocol)] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
		Class subclass = RACSwizzleClass(self, className);

		proxyingProtocol = protocol;
		delegater = object;
		originalSetterSelector = selector;
		originalSetterIMP = implementation;

		NSMutableSet* selectors = [[NSMutableSet alloc] init];
		NSMutableSet* returningSelectors = [[NSMutableSet alloc] init];
		NSMutableDictionary* signatures = [[NSMutableDictionary alloc] init];

		// Implement all protocol requirements as `_objc_msgForward`.

		unsigned int count;
		struct objc_method_description *list;

		// Optional requirements.
		list = protocol_copyMethodDescriptionList(protocol, false, true, &count);
		for (unsigned int i = 0; i < count; i++) {
			RACCheckTypeEncoding(list[i].types);
			NSMethodSignature* signature = [NSMethodSignature signatureWithObjCTypes:list[i].types];
			NSValue* key = [NSValue valueWithPointer:list[i].name];

			if (strcmp(signature.methodReturnType, @encode(void)) == 0) {
				[selectors addObject:key];
			} else {
				[returningSelectors addObject:key];
			}

			[signatures setObject:signature forKey:key];

			class_replaceMethod(subclass, list[i].name, _objc_msgForward, list[i].types);
			class_replaceMethod(subclass, RACAliasForSelector(list[i].name), _objc_msgForward, list[i].types);
		}
		free(list);

		// Mandatory requirements.
		list = protocol_copyMethodDescriptionList(protocol, true, true, &count);
		for (unsigned int i = 0; i < count; i++) {
			RACCheckTypeEncoding(list[i].types);
			NSValue* key = [NSValue valueWithPointer:list[i].name];
			[signatures setObject:[NSMethodSignature signatureWithObjCTypes:list[i].types] forKey:key];

			class_replaceMethod(subclass, list[i].name, _objc_msgForward, list[i].types);
			class_replaceMethod(subclass, RACAliasForSelector(list[i].name), _objc_msgForward, list[i].types);
		}
		free(list);

		optionalSelectors = selectors;
		optionalReturningSelectors = returningSelectors;
		methodSignatures = signatures;
	}

	return self;
}

-(void)setDelegate:(nullable id)delegate {
	_delegate = delegate;
	[self updateDelegator];
}

-(void)updateDelegator {
	// Since classes might cache information about delegates, the proxy is reset
	// to the delegater every time things might have changed.
	originalSetterIMP(delegater, originalSetterSelector, self);
}

-(BOOL)conformsToProtocol:(Protocol *)aProtocol {
	return aProtocol == proxyingProtocol;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSValue* pointer = [NSValue valueWithPointer:aSelector];
	NSMethodSignature * signature = [methodSignatures objectForKey:pointer];

	if (signature == nil) {
		signature = [_delegate methodSignatureForSelector:aSelector];
	}

	return signature;
}

-(BOOL)respondsToSelector:(SEL)aSelector {
	if ([optionalReturningSelectors containsObject:[NSValue valueWithPointer:aSelector]] && ![_delegate respondsToSelector:aSelector]) {
		return NO;
	}

	return class_getInstanceMethod(object_getClass(self), aSelector) != nil;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
	const char* selectorString = sel_getName(anInvocation.selector);
	if (strncmp(selectorString, "rac_swift_", 10) == 0) {
		anInvocation.selector = sel_registerName(selectorString + 10);
	}

	if ([_delegate respondsToSelector:anInvocation.selector]) {
		[anInvocation setTarget:_delegate];
		[anInvocation invoke];
		return;
	}

	NSValue* pointer = [NSValue valueWithPointer:anInvocation.selector];

	if ([object_getClass(self) instancesRespondToSelector:anInvocation.selector] && ![optionalReturningSelectors containsObject:pointer]) {
		return;
	}

	[super doesNotRecognizeSelector:anInvocation.selector];
}
	
	@end
NS_ASSUME_NONNULL_END
