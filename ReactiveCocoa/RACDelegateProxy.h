#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RACDelegateProxy : NSObject

@property (nonatomic, weak) id delegate;

-(instancetype)initWithProtocol:(Protocol *)protocol forObject:(id)object originalSetterSelector:(SEL)selector IMP:(void(*)(id, SEL, id _Nullable))implementation;
-(void)updateDelegator;

@end
NS_ASSUME_NONNULL_END
