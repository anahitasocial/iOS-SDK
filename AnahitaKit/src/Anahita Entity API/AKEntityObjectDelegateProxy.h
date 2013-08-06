//
//  AKEntityObjectDelegateProxy.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKEntityObject;
@protocol RKObjectLoaderDelegate;

/**
 @class AKEntityObjectDelegateProxy
 
 @abstract
 This class will intercept calls to delegate and 
 */
@interface AKEntityObjectDelegateProxy : AKArrayProxy

/**
 @method
 
 @abstract
 Initializes a proxy delegate, The loader delegate can be null
 */
- (id)initWithObjectEntity:(AKEntityObject*)entityObject
      objectLoaderDelegate:(id<RKObjectLoaderDelegate>)loaderDelegate;

@end
