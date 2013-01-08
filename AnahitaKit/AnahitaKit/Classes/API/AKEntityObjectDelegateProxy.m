//
//  AKEntityObjectDelegateProxy.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

@interface AKEntityObjectDelegateProxy() <RKObjectLoaderDelegate>

@end

@implementation AKEntityObjectDelegateProxy
{
    AKEntityObject *_entityObject;
    id<RKObjectLoaderDelegate> _objectLoaderDelegate;
}

- (id)initWithObjectEntity:(AKEntityObject*)entityObject
      objectLoaderDelegate:(id<RKObjectLoaderDelegate>)loaderDelegate
{
    if ( self = [super initWithObjects:entityObject,loaderDelegate, nil] ) {
        _entityObject = entityObject;
        _objectLoaderDelegate = loaderDelegate;
    }
    return self;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if ( [error validationDidFail] && objectLoader.sourceObject ) {
        [self forwardMethodCall:@selector(entityObject:didFailValidation:) toObjects:_proxiedObjects withArgs:objectLoader.sourceObject, error];
    }
    
    [self forwardMethodCall:_cmd toObjects:_proxiedObjects withArgs:objectLoader, error];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if ( objectLoader.method == RKRequestMethodPOST ||
         objectLoader.method == RKRequestMethodPUT
        ) {
        
    }
    
    [self forwardMethodCall:_cmd toObjects:_proxiedObjects withArgs:objectLoader, object];
}

@end
