//
//  AKObjectRepository.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class RKObjectMapping;
@class RKObjectManager;
@class RKObjectLoader;
@class RKObjectPaginator;


typedef void(^RKObjectLoaderBlock)(RKObjectLoader *loader);


/**
 @class AKObjectRepository
 
 @abstract
 
 An object repository is an abstract interface for interating with the REST API
 of a resource using the RestKit libraries
 
 */
@interface AKObjectRepository : NSObject

/** @abstract object mappings */
@property(nonatomic,readonly) AKObjectMappings *mappings;

/** @abstract object manager */
@property(nonatomic,readonly) RKObjectManager *manager;

/** @abstract object resource paths */
@property(nonatomic,readonly) AKObjectResourcePaths *paths;

///-----------------------------------------------------------------------------
/// @name Creating a Repository
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Creates a new repository for an entity class using its mapping
 
 @param Object Resource Router
 @param Object Mapping
 @param Object Manager
 @return A repository instance
 */
- (id)initWithObjectResourcePaths:(AKObjectResourcePaths*)paths
                     objectMappings:(AKObjectMappings*)mappings
                     objectManager:(RKObjectManager*)manager;
/**
 Loads an entity using the query parameters
 
 @param Query parameters passed as key/value pair dictionary
 @param Block to set the loading callbacks
 */
- (void)loadWithQueryDictionary:(NSDictionary*)dictionary loader:(RKObjectLoaderBlock)loader;

/**
 Returns a loader that loads a object
 
 @return object loader
 */
- (RKObjectLoader*)loaderWithQueryDictionary:(NSDictionary*)dictionary;

/**
 Loads a list of entities using the query parameters
 
 @param Query parameters passed as key/value pair dictionary
 @param Block to set the loading callbacks
 */
- (void)loadListWithQueryDictionary:(NSDictionary*)dictionary loader:(RKObjectLoaderBlock)loader;

/**
 Returns a loader that load list of objects
 
 @return objet loader
 */
- (RKObjectLoader*)listLoaderWithQueryDictionary:(NSDictionary*)dictionary;

/**
 Loads an entity identified by the passed in id.
 
 @param id The entity id
 @param Block to set the loading callbacks
 */
- (void)loadWithId:(NSUInteger)id loader:(RKObjectLoaderBlock)loader;

/**
 Return a loader for the object

 @param object
 @return Object loader
*/
- (RKObjectLoader*)loaderForObject:(id)object;

- (RKObjectPaginator*)paginator;

@end

#import "AKEntityObject.h"