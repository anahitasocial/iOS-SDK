//
//  AKObjectResourceRouter.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKObjectResourceRouter
 
 @abstract
 Create resource paths for a given resource
 
 */
@interface AKObjectResourceRouter : NSObject
{
    
@private
    AKObjectResourcePaths *_resource;
    NSString *_resourcePath;
    NSString *_resourcesPath;
}
///-----------------------------------------------------------------------------
/// @name Creating an object resource paths
///-----------------------------------------------------------------------------

/**
 @method
 
 @abstract
 Creates resouce paths from a resource object. It guesses the path from resource object class
 
 @param Resource object
 @return Resrouce paths
 */
- (id)initWithObjectResource:(AKObjectResourcePaths*)resource;

/**
 @method
 
 @abstract
 Creates resouce paths from a resource object. It prefixes all the paths with the
 prefix path
 
 @param Resource object
 @param Prefix path
 @return Resrouce paths
 */
- (id)initWithObjectResource:(AKObjectResourcePaths*)resource prefixPath:(NSString*)prefixPath;

/**
 @method
 
 @abstract
 Creates resouce paths from a resource object.
 
 @param Resource object
 @param Resource path
 @param Resource list path
 @return Resrouce paths
 */
- (id)initWithObjectResource:(AKObjectResourcePaths *)resource resourceBasePath:(NSString*)resourcePath
           resourcesBasePath:(NSString*)resourcesPath;

/** @abstract Return the router object resource */
@property(nonatomic,readonly) AKObjectResourcePaths *resource;

/** @abstract Return a single resource path */
@property(nonatomic,readonly) NSString *resourcePath;

/** @abstract Return a list resource path */
@property(nonatomic,readonly) NSString *resourcesPath;

/***
 Return the resource path an object
 
 @return resource path
 */
- (NSString*)resourcePathForObject:(id)object;

/**
 Return the resource path /component_name/resource_name
 
 @return String resource path
 */
- (NSString*)resourcePath;

/**
 Return a resource path. By default params are added as query parameters according to RFC 1808.
 
 @return Resource path
 */
- (NSString*)resourcePathWithQueryDictionary:(NSDictionary *)dictionary;

/**
 Return the resources path /component_name/resources_name
 
 @return String resources path
 */
- (NSString*)resourcesPath;

/**
 Return the resources path. By default params are added as query parameters according to RFC 1808.
 
 @return Resource path
 */
- (NSString*)resourcesPathWithQueryDictionary:(NSDictionary*)dictionary;

@end
