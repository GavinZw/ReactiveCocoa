#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACDelegateProxy.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
Class _Nullable RACSwizzleClass(NSObject *, NSString * _Nullable);
void RACCheckTypeEncoding(const char *typeEncoding);
SEL RACAliasForSelector(SEL originalSelector);

@interface NSObject (RACObjCRuntimeUtilities)

/// Register a block which would be triggered when `selector` is called.
///
/// Warning: The callee is responsible for synchronization.
-(BOOL) _rac_setupInvocationObservationForSelector:(SEL)selector protocol:(nullable Protocol *)protocol receiver:(void (^)(void)) receiver;
-(RACDelegateProxy*) _rac_delegateProxyForSelector:(SEL)selector withProtocol:(Protocol *)protocol;

@end
NS_ASSUME_NONNULL_END
