//
//  MessageForwarding.m
//  Study
//
//  Created by Lang on 2019/5/26.
//  Copyright © 2019 lanbao. All rights reserved.
//

#import "MessageForwarding.h"
#import "MessageForwardingHandler.h"
#import "MessageForwardingHandler2.h"

@implementation MessageForwarding

/*
 结合NSObject文档可以知道，_objc_msgForward消息转发做了如下几件事：
 1.调用resolveInstanceMethod:方法，允许用户在此时为该Class动态添加实现。如果有实现了，则调用并返回。如果仍没实现，继续下面的动作。
 
 2.调用forwardingTargetForSelector:方法，尝试找到一个能响应该消息的对象。如果获取到，则直接转发给它。如果返回了nil，继续下面的动作。
 
 3.调用methodSignatureForSelector:方法，尝试获得一个方法签名。如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。
 
 4.调用forwardInvocation:方法，将地3步获取到的方法签名包装成Invocation传入，如何处理就在这里面了。
 
 上面这4个方法均是模板方法，开发者可以override，由runtime来调用。最常见的实现消息转发，就是重写方法3和4，吞掉一个消息或者代理给其他对象都是没问题的。
 
 Table 6-1  Objective-C type encodings
 Code
 
 Meaning
 
 c A char
 
 i An int
 
 s A short
 
 l A long
 
 l is treated as a 32-bit quantity on 64-bit programs.
 
 q A long long
 
 C An unsigned char
 
 I An unsigned int
 
 S An unsigned short
 
 L An unsigned long
 
 Q An unsigned long long
 
 f A float
 
 d A double
 
 B A C++ bool or a C99 _Bool
 
 v A void
 
 * A character string (char *)
 
 @ An object (whether statically typed or typed id)
 
 # A class object (Class)
 
 : A method selector (SEL)
 
 [array type] An array
 
 {name=type...} A structure
 
 (name=type...) A union
 
 bnum A bit field of num bits
 
 ^type A pointer to type
 
 ? An unknown type (among other things, this code is used for function pointers)
 

 */

+ (BOOL)resolveClassMethod:(SEL)sel {
    return NO;
}

// 1、如果这个方法返回 NO 然后调用 2
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
    if (sel == @selector(instanceMethodTest)) {
        /*
        // 或者 IMP dynamicImp = [self instanceMethodForSelector:方法名];
        IMP dynamicImp = imp_implementationWithBlock(^(void){
            NSLog(@"dynamicAddMethod");
        });
         */
        Method addMethod = class_getInstanceMethod([self class], @selector(dynamicAddMethod));
        IMP dynamicImp = method_getImplementation(addMethod);
        // encodeing 也可以用 "v@:" 表示
        const char *encoding = method_getTypeEncoding(addMethod);
        return class_addMethod([self class], sel, dynamicImp, encoding);
    }
    return NO;
}
// 2、如果这个方法返回 nil 然后调用 3
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
    if (aSelector == @selector(instanceMethodTest)) {
        MessageForwardingHandler *handler = [MessageForwardingHandler new];
        return handler;
    }
    return [super forwardingTargetForSelector:aSelector];
}
// 3、获取方法的签名，然后跳用 4
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([MessageForwardingHandler instancesRespondToSelector:aSelector]) {
            signature = [MessageForwardingHandler instanceMethodSignatureForSelector:aSelector];
            //signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        }
    }
    return signature;
}
// 4、
//NSInvocation对象中保存着我们调用一个method的所有信息。可以看下其属性和方法：
//methodSignature 含有返回值类型，参数个数及每个参数的类型 等信息。
//- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;获取调用method时传的参数
//- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx; 设置第index参数。
//- (void)invoke; 开始执行
//- (void)getReturnValue:(void *)retLoc; 获取返回值
//链接：https://juejin.im/post/5a30c6fdf265da4319564272

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([MessageForwardingHandler instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[MessageForwardingHandler new]];
    }
    if ([MessageForwardingHandler2 instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[MessageForwardingHandler2 new]];
    }
}

- (void)dynamicAddMethod {
    NSLog(@"dynamicAddMethod");
}


@end
