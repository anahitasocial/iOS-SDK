//
//  NSObject+AKCore.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <objc/runtime.h>


@implementation NSObject(AKCore)

- (void)performSelector:(SEL)aSelector withArgs:arg1,...
{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSAssert(signature, @"unrecognized selector sent to instance %@",self);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    int numOfArgs = [signature numberOfArguments];
    va_list args;
    va_start(args, arg1);
    int i = 2;
    void* arg = (__bridge void*)arg1;
    for (; i < numOfArgs; i++) {
        [invocation setArgument:&arg atIndex:i];
        arg = va_arg(args, void*);
    }
    va_end(args);
    [invocation invoke];
}

@end
