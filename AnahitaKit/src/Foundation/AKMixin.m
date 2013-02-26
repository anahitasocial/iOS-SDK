//
//  AKMixin.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <objc/runtime.h>
#import "AKFoundationMethods.h"
#import "AKMixin.h"

static inline void* __AKInvokeSelectorWithArgs(id s, SEL cmd, va_list args, BOOL addTargetAsArg)
{
    NSMethodSignature *signature = [s methodSignatureForSelector:cmd];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    int i = 2;
    if ( addTargetAsArg && false ) {
        void *target = (__bridge void *)(s);
        [invocation setArgument:&target atIndex:i++];
    }
    for(;i < [signature numberOfArguments];i++) {
        void *v = va_arg(args, void *);
        [invocation setArgument:&v atIndex:i];
    }
    va_end(args);
    invocation.target   = s;
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
}

static inline void __AKApplyMixinToClass(Class class, id mixinClass, NSMutableArray *mixableSelectors)
{
    BOOL shouldMix = YES;
    
    if ( [mixinClass respondsToSelector:@selector(mixinShouldMixWithClass:)] ) {
        shouldMix = [mixinClass mixinShouldMixWithClass:class];
    }
    
    if ( !shouldMix ) {
        return;
    }
    
    if ( [mixinClass respondsToSelector:@selector(mixinWillMixSelectors:withClass:)] ) {
        [mixinClass mixinWillMixSelectors:mixableSelectors withClass:class];
    }
    
    for(int i=0;i < mixableSelectors.count ;i++)
    {
        NSString *selectorName = [mixableSelectors objectAtIndex:i];
        SEL selector = NSSelectorFromString(selectorName);
        class_copyMethod(mixinClass, selector, class, selector);
    }

    if ( [mixinClass respondsToSelector:@selector(mixinDidMixSelectors:withClass:)] ) {
        [mixinClass mixinDidMixSelectors:mixableSelectors withClass:class];
    }
    
}

static inline NSSet* __AKMixinsForClass(Class class, Protocol *mixinProtocol, NSString* mixinPostfix)
{
    unsigned int count = 0;
    
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(class, &count);
    NSMutableSet *mixins = [NSMutableSet set];
    for(int i=0;i<count;i++) {
        Protocol *protocol = protocols[i];
        //if the protocol is a mixin
        //try to find the mixin
        if ( protocol_conformsToProtocol(protocol, mixinProtocol) )
        {

            NSString *className =[[NSString stringWithCString:protocol_getName(protocol) encoding:NSASCIIStringEncoding] stringByAppendingString:mixinPostfix];

            Class mixin =  NSClassFromString(className);
            //if mixin exists then add the mixin class
            if ( mixin != nil ) {
                [mixins addObject:NSStringFromClass(mixin)];
            }
        }
    }
    if ( protocols )
        free(protocols);
    
    //try to get the parent protocols since class_copyProtocolList doesn't
    //return it
    Class parent = class_getSuperclass(class);
    
    if ( parent ) {
        [mixins unionSet:__AKMixinsForClass(parent, mixinProtocol, mixinPostfix)];
    }
    
    return mixins;
}

static inline void __AKApplyMixinsForClass(Class class, NSArray *mixins)
{
   [mixins enumerateObjectsUsingBlock:^(NSString *mixinName, NSUInteger idx, BOOL *stop) {
        NSMutableArray *mixableSelectors = [NSMutableArray array];
        Class mixin = NSClassFromString(mixinName);
        Protocol *protocol = NSProtocolFromString(mixinName);
        //get all the mixable selectors
        unsigned int methodCount = 0;
        struct objc_method_description* descriptions = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
        for(int i=0;i < methodCount ;i++)
        {
            struct objc_method_description description = descriptions[i];
            NSString *selectorName = NSStringFromSelector(description.name);
            [mixableSelectors addObject:selectorName];
        }
        if ( descriptions )
            free(descriptions);
        
        __AKApplyMixinToClass(class, mixin, mixableSelectors);
   }];
}

void APPLY_MIXINS()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        int numClasses;
        Class * classes = NULL;
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        Protocol *protocol = @protocol(AKBehavior);
        NSString *postFix = @"";
        if (numClasses > 0 )
        {
            int total = sizeof(Class) * numClasses;
            classes = (__unsafe_unretained Class *)malloc(total);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                Class class = classes[i];
                if ( class_conformsToProtocol(class, protocol) ) {
                    NSArray* mixinClasses = [__AKMixinsForClass(class, protocol, postFix) allObjects];
                    __AKApplyMixinsForClass(class, mixinClasses);
                }
            }
            free(classes);
        }
    });    
}

