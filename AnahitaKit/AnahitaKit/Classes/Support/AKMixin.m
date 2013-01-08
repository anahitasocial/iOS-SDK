//
//  AKMixin.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <objc/runtime.h>

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

static inline void __AKApplyMixinToClass(Class class, Class mixinClass, NSMutableArray *mixableSelectors)
{    
    for(int i=0;i < mixableSelectors.count ;i++)
    {       
        NSString *selectorName = [mixableSelectors objectAtIndex:i];
        SEL selector = NSSelectorFromString(selectorName);
        if ( !class_respondsToSelector(mixinClass, selector) ) {
            NIDPRINT(@"Method %@ is not present in mixin %@ when mixing with %@",NSStringFromSelector(selector), mixinClass, class);
            continue;
        }
        Method method = class_getInstanceMethod(mixinClass, selector);
        IMP imp = method_getImplementation(method);
        const char* types = method_getTypeEncoding(method);
        
        //already contains the mixed method
        //@TODO maybe a graceful handling
        if ( !class_addMethod(class, selector, imp, types) ) {
            NIDPRINT(@"Method %@ already exists in %@",NSStringFromSelector(selector), class);
            continue;
        } 
    }

    if ( [mixinClass respondsToSelector:@selector(mixedWithClass:)] ) {
        [mixinClass performSelector:@selector(mixedWithClass:) withObject:class];
    }
    
}

static inline NSArray* __AKMixinsForClass(Class class)
{
    unsigned int count = 0;
    
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(class, &count);
    NSMutableArray *mixins = [NSMutableArray array];
    for(int i=0;i<count;i++) {
        Protocol *protocol = protocols[i];
        //if the protocol is a mixin
        //try to find the mixin
        if ( protocol_conformsToProtocol(protocol, @protocol(AKMixin)) )
        {
            Class mixin = objc_getClass(protocol_getName(protocol));
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
        [mixins addObjectsFromArray:__AKMixinsForClass(parent)];
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

void __APPLY_MIXINS()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        int numClasses;
        Class * classes = NULL;
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0 )
        {
            int total = sizeof(Class) * numClasses;
            classes = (__unsafe_unretained Class *)malloc(total);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                Class class = classes[i];
                if ( class_conformsToProtocol(class, @protocol(AKMixin)) ) {
                    NSArray* mixinClasses = __AKMixinsForClass(class);
                    __AKApplyMixinsForClass(class, mixinClasses);
                }
            }
            free(classes);
        }
    });    
}

//        if ( false )
//        {
//        __block void* (^forwardMessageBlock)(id s,...) = ^(id s, ...)
//        {
//            va_list args;
//            va_start(args, s);
//            return __AKInvokeSelectorWithArgs(s,selector,args,YES);
//        };
//        
//        IMP blockIMP = imp_implementationWithBlock(forwardMessageBlock);
//        
//        BOOL added = class_addMethod(class, description.name, blockIMP, description.types);
//        //if a class is overriding the protocol method then we need to handle
//        //calling the parent        
//        if ( !added)
//        {
//            //get the original method
//            Method existingMethod = class_getInstanceMethod(class, description.name);
//            //create a fake method
//            NSString *strNewSelector = [@"__" stringByAppendingString:NSStringFromSelector(description.name)];
//            __block SEL newSelector = NSSelectorFromString(strNewSelector);
//            class_addMethod(class, newSelector, method_getImplementation(existingMethod), description.types);
//            __block BOOL callparent = NO;
//            IMP newblock = imp_implementationWithBlock(^(id s, ...){
//                va_list args;
//                va_start(args, s);                
//                void *returnValue;
//                if ( !callparent ) {
//                    callparent  = YES;
//                    returnValue = __AKInvokeSelectorWithArgs(s,newSelector,args,NO);
//                } else {
//                    callparent  = NO;
//                    returnValue = __AKInvokeSelectorWithArgs(s,selector,args,YES);
//                }
//                return returnValue;
//            });
//            class_replaceMethod(class, description.name, newblock, description.types);
//        }
//        }

