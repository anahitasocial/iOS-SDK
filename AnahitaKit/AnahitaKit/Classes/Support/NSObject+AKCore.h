//
//  NSObject+AKCore.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@interface NSObject(AKCore)

/** 
 @method
 
 @abstract
*/
+ (id)instantiateUsingBlock:(void(^)(id instance))block;

- (void)performSelector:(SEL)aSelector withArgs:arg1,...;

@end
