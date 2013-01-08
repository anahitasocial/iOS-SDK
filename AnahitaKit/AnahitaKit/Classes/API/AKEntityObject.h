//
//  AKEntity.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKObjectResourceRouter;
@class AKObjectResourcePaths;
@class RKObjectMapping;
@class RKObjectLoader;
@class AKObjectMapping;
@class AKObjectLoaderFactory;
@protocol RKObjectLoaderDelegate;
@class AKEntityObject;
@class RKObjectPaginator;

#import "AKEntityAttributes.h"

/**
 @class AKQueryObject
 
 @abstract
 Abstract the query request
 */
@interface AKQueryObject : NSObject
{
   RKObjectMapping *_querySerializer;
}

/** 
 @method
 
 @abstract
*/
+ (id)queryUsingBlock:(void(^)(id query))block;

@property(readonly,nonatomic) NSDictionary *serializedValues;

@end

/**
 @protocol AKEntityObjectProtocol
 
 @abstract
 Extends object loader protocol to add more abstraction
 */
@protocol AKEntityObjectDelegate <RKObjectLoaderDelegate>

@optional

/**
 @method
 
 @abstract
 called when an entity object has been loaded
 */
- (void)entityObject:(AKEntityObject*)entityObject didFailValidation:(NSError*)error;

/**
 @method
 
 @abstract
 called when an entity object has been loaded
 */
- (void)entityObjectDidLoad:(AKEntityObject*)entityObject;

/**
 @method
 
 @abstract
 called when an entity object has been save or created
 */
- (void)entityObjectDidSave:(AKEntityObject*)entityObject;

@end

/**
 @class AKEntityObject
 
 @abstract
 Base object that represents a remote entity. The only requirements is that it must have a integer based id
 
 */
@interface AKEntityObject : NSObject <AKEntityObjectDelegate, NSCopying>

/**
 @method
 
 @abstract
 Return the entity shared configuration
 */
+ (AKEntityConfiguration*)sharedConfiguration;

/**
 @method
 
 @abstract
 This method is called by the configurator to configure an entity. Subclasses
 should overwrite the method to add exrta configuration
 */
+ (void)configureObjectEntity:(AKEntityConfiguration*)configuration;

/**
 @method
 
 @abstract 
 Initializes an entity with a dictionary of values
 
 @param Dictionary of values
 @return Entity object
 */
+ (id)objectWithValues:(NSDictionary*)values;

/**
 @method
 
 @abstract
 Initializes an entity with a dictionary of values
 
 @param Dictionary of values
 @return Entity object
 */
- (id)initWithValues:(NSDictionary*)values;

/**
 @method

 @abstract
 Initializes an entity using its id
 
 @param The id of the entity
 @return Entity object
 */
- (id)initWithId:(NSUInteger)identifier;

/**
 @method
 
 @abstract
 Initializes an entity using a block
 
 @param The initailizer block
 @return Entity object
 */
+ (id)objectWithBlock:(void(^)(id object))block;

/**
 @method
 
 @abstract
 Initializes an entity using an id
 
 @param The initailizer block
 @return Entity object
 */
+ (id)objectWithId:(NSUInteger)objectId;

/**
 @method
 
 @abstract
 Initializes an entity using a block
 
 @param The initailizer block
 @return Entity object
 */
- (id)initWithBlock:(void(^)(id object))block;

/** @abstract Entity ID. Must be an integer */
@property (nonatomic,strong) NSNumber *identifier;

/** @abstract Commands property */
@property (nonatomic,strong) AKCommandList *commands;

/** @abstract Return a new instance of object loader */
@property (nonatomic,readonly) RKObjectLoader *objectLoader;

/** @abstract Return the object resource path */
@property (nonatomic,readonly) NSString *resourcePath;

/** @abstract Return the shared configuration instance */
@property (nonatomic,readonly) AKEntityConfiguration *sharedConfiguration;

///-----------------------------------------------------------------------------
/// @name Loading collection
///-----------------------------------------------------------------------------

+ (RKObjectLoader*)loaderWithQuery:(id)query;
+ (RKObjectPaginator*)paginatorWithQuery:(id)query;

///-----------------------------------------------------------------------------
/// @name Loading an object
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Loads an object. The loader callback can be set using the block
 
 @param A block to configure the loader
 */
- (void)loadWithBlock:(void (^)(RKObjectLoader*loader))block;

/**
 @method
 
 @abstract
 Loads an object. The loader will callback on the passed delegate

 @param Loader delegate
*/
- (void)loadWithDelegate:(id<RKObjectLoaderDelegate>)delegate;

/**
 @method
 
 @abstract
 load an object synchoronously and return true or false
 
 @return true if object loaded or false if not
 */
- (BOOL)load;

/**
 @method
 
 @abstract
 Loads an entity and return error if there are any
 
 @return true if object loaded or false if not
 */
- (BOOL)load:(NSError**)error;

///-----------------------------------------------------------------------------
/// @name Deleting anobject
///-----------------------------------------------------------------------------

- (void)delete:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure;

///-----------------------------------------------------------------------------
/// @name Saving an object
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Saves an entity with a block
 
 @param A block to configure the loader
 */
- (void)saveWithBlock:(void (^)(RKObjectLoader*loader))block;

/**
 @method
 
 @abstract
 Saves an entity with a delegate
 
 @param Loader delegate
 */
- (void)saveWithDelegate:(id<RKObjectLoaderDelegate>)delegate;

/**
 @method
 
 @abstract
 Try to saves an object synchoronously and return true of false 
 
 @return true or false
 */
- (BOOL)save:(NSError**)error;

/**
 @method
 
 @abstract
 Try to saves an object synchoronously and return true of false
 
 @return true or false
 */
- (BOOL)save;

///-----------------------------------------------------------------------------
/// @name Validating an object
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Validates an entity. Errors added to the entity error stack
 
 @return Whether an entity has passed validation or not
 */
- (BOOL)validateValuesForKeys:(NSArray*)keys error:(NSError**)error;

@end

#import "AKEntityMixins.h"
#import "AKActorObject.h"
#import "AKSessionObject.h"
#import "AKMediumObject.h"
#import "AKStoryObject.h"