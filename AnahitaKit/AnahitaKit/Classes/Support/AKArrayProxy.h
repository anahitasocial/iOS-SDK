//
//  AKObjectDecorator.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-25.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKArrayProxy
 
 @abstract
 Creates a proxy of an array of objects. By default it forward all the messages
 to the proxied objects
 */
@interface AKArrayProxy : NSObject
{
    
@protected
    NSArray *_proxiedObjects;
}

/**
 @method
 
 @abstract
 Forwards invocation to an array of objects. If forwarded it returns true
 otherwise it returns false
 */
- (BOOL)forwardInvocation:(NSInvocation *)invocation toObjects:(NSArray*)objects;

/**
 @method
 
 @abstract
 Forwards invocation to an array of objects. If forwarded it returns true
 otherwise it returns false
 */
- (void)forwardMethodCall:(SEL)selector toObjects:(NSArray*)objects withArgs:arg1,...;

/**
 @method
 
 @abstract 
 Initializes the proxy with an object
 */
- (id)initWithObject:(id<NSObject>)object;

/**
 @method
 
 @abstract
 Initializes the proxy with an array of objects
 */
- (id)initWithArrayOfObjects:(NSArray*)objects;

/**
 @method
 
 @abstract
 Initializes the proxy from a list of objects
 */
- (id)initWithObjects:(id)object,... NS_REQUIRES_NIL_TERMINATION;

@end
