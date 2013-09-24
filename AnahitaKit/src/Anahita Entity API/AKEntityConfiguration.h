//
//  AKEntityConfiguration.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class RKObjectMapping;

/**
 @class AKEntityConfiguration
 
 @abstract
 Contain a set of properties that configures an entity, such as mappings, resource paths and etc
 */
@interface AKEntityConfiguration : NSObject

/**
 @method
 
 @abstract
 Instantiates a configuration for a class
 */
- (id)initWithObjectClass:(Class)class;

/** @abstract object class */
@property(nonatomic,readonly) Class objectClass;

/** @abstract contains object mappings for an object */
@property(nonatomic,strong) AKObjectMapping *objectMapping;

/** @abstract contains object mappings for an object */
@property(nonatomic,strong) AKObjectMapping *collectionMapping;

/** @abstract contains object mappings for an object */
@property(nonatomic,strong) RKObjectMapping *objectSerializer;

/** @abstract object manager*/
@property(nonatomic,strong) RKObjectManager *objectManager;

/** @abstract delegate forwarder class */
@property(nonatomic,strong) Class delegateProxyClass;

/**
 @property
 
 @abstract
 path that represent a collection of resources
 The path can contain :[a-z] placeholder that will be interpolated with key/value object
 */
@property(nonatomic,strong) NSString* collectionResourcePath;

/**
 @property
 
 @abstract
 resource path. The path can contain :[a-z] placeholder that will be interpolated with key/value object
 */
@property(nonatomic,strong) NSString* itemResourcePath;

/**
 @method
 
 @abstract
 Maps a set of attributes. This attributes are mapped both for the object mapping and 
 object serializer
 
 */
- (void)mapAttributes:(NSString *)attributeKey, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @method
 
 @abstract
 Maps a keypath to an attribute for the object mapping and attribute to keypath for the object
 serializer 
 */
- (void)mapKeyPath:(NSString*)sourceKeyPath toAttribute:(NSString*)destinationAttribute;

/** @abstract Collection rootkey */
@property(nonatomic,copy) NSString *collectionRootKeyPath;

@end
