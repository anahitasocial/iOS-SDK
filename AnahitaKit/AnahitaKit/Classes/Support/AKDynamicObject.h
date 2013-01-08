//
//  AKDynamicObject.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

id AKBlockFromTargetSelector(id target, SEL cmd, ...);

#define block_fom_selector(selector, ...) AKBlockFromTargetSelector(self, selector, __VA_ARGS__)
#define create_block_from_selector(selector,...) AKBlockFromTargetSelector(self, selector, __VA_ARGS__)

/**
 @class AKDynamicObject
 
 @abstract
 Provides a way to add methods to this object dynamically using block.
 */
@interface AKDynamicObject : NSObject

+ (id)dynamicObjectWithMethods:(void *)arg1,...NS_REQUIRES_NIL_TERMINATION;

- (void)addMethodForSEL:(SEL)selector withBlockImplementation:(id)imp;

@end

//a macro to create dynamic objects

#define $$(...) \
    [AKDynamicObject dynamicObjectWithMethods:__VA_ARGS__,nil];