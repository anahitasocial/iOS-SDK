//
//  AKDynamicObject.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

id AKBlockFromTargetSelector(id target, SEL cmd, ...)
{
    va_list args;
    va_start(args, cmd);
    id v;
    __block NSMutableArray *vargs = [NSMutableArray array];
    while ((v = va_arg(args, id)) != nil) {
        [vargs addObject:v];
    };
    va_end(args);
    __block int size = [vargs count];
    id block = ^(void* arg1, ...) {
        va_list args;
        NSMethodSignature *signature = [target methodSignatureForSelector:cmd];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        int argIndex  = 2;
        for(int j=0;j<size;j++) {
            id v = [vargs objectAtIndex:j];
            [invocation setArgument:&v atIndex:argIndex++];
        }
        va_start(args, arg1);
        [invocation setArgument:&arg1 atIndex:argIndex++];
        while(argIndex < [signature numberOfArguments]) {
            void *v = va_arg(args, void *);
            [invocation setArgument:&v atIndex:argIndex++];
        }
        va_end(args);
        invocation.target   = target;
        invocation.selector = cmd;
        [invocation invoke];
        NSUInteger returnLength = [signature methodReturnLength];
        if ( returnLength > 0 ) {
            void *buffer;
            [invocation getReturnValue:&buffer];
            return buffer;
        } else {
            return nil;
        }        
    };
    return block;
}

@implementation AKDynamicObject
{
    NSMutableDictionary *_blockMethods;
}

+ (id)dynamicObjectWithMethods:(void *)arg1,...NS_REQUIRES_NIL_TERMINATION
{
    AKDynamicObject *dynamicObject = [[self alloc] init];
    va_list args;
    va_start(args, arg1);    
    void* selector = arg1;
    while (selector != nil) {
        id block = va_arg(args, id);
        [dynamicObject addMethodForSEL:selector withBlockImplementation:block];
        selector = va_arg(args, void *);
    }
    return dynamicObject;
}

- (id)init
{
    if ( self = [super init] ) {
        _blockMethods = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addMethodForSEL:(SEL)selector withBlockImplementation:(id)imp
{
    [_blockMethods setValue:imp forKey:NSStringFromSelector(selector)];
}


- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ( [super respondsToSelector:aSelector] ) {
        return true;
    } else {
        return NULL != [_blockMethods valueForKey:NSStringFromSelector(aSelector)];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (signature == nil) {
        NSString *strSelector = NSStringFromSelector(aSelector);
        if ( NULL != [_blockMethods valueForKey:strSelector] ) {
            NSMutableString *encoding = [NSMutableString stringWithString:@"v@:"];
            int count = [strSelector countOccurancesOfSubstring:@":"];
            for(int i=0;i<count;i++) {
                [encoding appendString:@"^v"];
            }
            const char *encodingTypes = [encoding cStringUsingEncoding:NSUTF8StringEncoding];
            signature = [NSMethodSignature signatureWithObjCTypes:encodingTypes];
        }
    }
    
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)invocation
{
   //lets get the block for the selector
    NSString *strSelector = NSStringFromSelector(invocation.selector);
    if ( [_blockMethods valueForKey:strSelector] != NULL ) {
        void(^block)() = [_blockMethods valueForKey:strSelector];
        int numOfArgs  = invocation.methodSignature.numberOfArguments - 2;
        void*(^args)(int index) = ^(int index) {
            void *arg;
            [invocation getArgument:&arg atIndex:index + 2];
            return arg;
        };
        
        //haven't found a better way to dynmcally call the block
        switch (numOfArgs) {
            case 0:block();break;
            case 1:block(args(0));break;
            case 2:block(args(0),args(1));break;
            case 3:block(args(0),args(1),args(2),args(3));break;
            case 4:block(args(0),args(1),args(2),args(3),args(4));break;
            case 5:block(args(0),args(1),args(2),args(3),args(4),args(5));break;
        }       
    }
    else {
        [self forwardInvocation:invocation];
    }
}

@end
