//
//  NSObject+AKCore.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#ifndef SYNTHESIZE_PROPERTY
#define THREE_WAY_PASTER_INNER(a, b, c) a ## b ## c
#define THREE_WAY_PASTER(x,y,z) THREE_WAY_PASTER_INNER(x,y,z)

#define SYNTHESIZE_PROPERTY_WITH_KEY(type, setter, getter, key, policy) \
static void * const key = (void*)&key; \
\
- (type)getter { return objc_getAssociatedObject(self, THREE_WAY_PASTER(__ASSOCIATED_STORAGE_KEY_, getter,__LINE__) ); } \
\
- (void)setter: (type)value { objc_setAssociatedObject(self, THREE_WAY_PASTER(__ASSOCIATED_STORAGE_KEY_, getter,__LINE__) , value, policy); } \
    
#define SYNTHESIZE_PROPERTY(type, setter, getter, policy) \
    SYNTHESIZE_PROPERTY_WITH_KEY(type,setter,getter, THREE_WAY_PASTER(__ASSOCIATED_STORAGE_KEY_, getter, __LINE__), OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    
#define SYNTHESIZE_PROPERTY_STRONG(type,setter,getter) \
    SYNTHESIZE_PROPERTY(type,setter,getter, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

#define SYNTHESIZE_PROPERTY_WEAK(type,setter,getter) \
    SYNTHESIZE_PROPERTY(type,setter,getter, OBJC_ASSOCIATION_ASSIGN)

#define SYNTHESIZE_PROPERTY_COPY(type,setter,getter) \
    SYNTHESIZE_PROPERTY(type,setter,getter, OBJC_ASSOCIATION_COPY_NONATOMIC)

#endif


@interface NSObject(AKCore)

/** 
 @method
 
 @abstract
*/
- (void)performSelector:(SEL)aSelector withArgs:arg1,...;

@end
