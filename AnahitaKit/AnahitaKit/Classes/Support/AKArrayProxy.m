//
//  AKObjectDecorator.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKArrayProxy.h"

/**
 Array of proxied objects
 */

@implementation AKArrayProxy

- (id)initWithObjects:(id)object, ...
{
    NSMutableArray *objects = [NSMutableArray array];
    va_list args;
    va_start(args, object);
    for (id arg = object; arg != nil; arg = va_arg(args, id)) {
        [objects addObject:arg];
    }
    va_end(args);
    return [self initWithArrayOfObjects:objects];
}

- (id)initWithObject:(id)object
{
    if ( self = [super init] ) {
        _proxiedObjects = @[object];
    }
    return self;
}

- (id)initWithArrayOfObjects:(NSArray *)objects
{
    if ( self = [super init] ) {
        _proxiedObjects = [NSArray arrayWithArray:objects];
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ( [super respondsToSelector:aSelector] ) {
        return true;
    } else {
        for (id object in _proxiedObjects ) {
            if ( [object respondsToSelector:aSelector] ) {
                return true;
            }
        }
    }
    return false;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature == nil) {
        for (id object in _proxiedObjects) {
            if ([object respondsToSelector:selector]) {
                signature = [object methodSignatureForSelector:selector];
                
                return signature;
            }
        }
    }
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)invocation
{    
    if ( NO == [self forwardInvocation:invocation toObjects:_proxiedObjects]) {
        [super forwardInvocation:invocation];
    }
    
}

- (BOOL)forwardInvocation:(NSInvocation *)invocation toObjects:(NSArray*)objects
{
    BOOL didForward = NO;
    
    for (id object in objects) {
        if ([object respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:object];
            didForward = YES;
        }
    }
    
    return didForward;
}

- (void)forwardMethodCall:(SEL)selector toObjects:(NSArray*)objects withArgs:arg1,...
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if ( signature != NULL ) {
        int numOfArgs = [signature numberOfArguments];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        va_list args;
        va_start(args, arg1);
        int i = 2;
        void* arg = (__bridge void*)arg1;
        for (; i < numOfArgs; i++) {
            [invocation setArgument:&arg atIndex:i];
            arg = va_arg(args, void*);
        }
        va_end(args);
        [self forwardInvocation:invocation toObjects:objects];
    }
}

@end
