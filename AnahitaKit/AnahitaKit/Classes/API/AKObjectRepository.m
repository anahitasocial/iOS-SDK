//
//  AKObjectRepository.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "NSString+NimbusCore.h"

#import "RestKit.h"

@implementation AKObjectRepository

- (id)initWithObjectResourcePaths:(AKObjectResourcePaths*)paths
                   objectMappings:(AKObjectMappings*)mappings
                    objectManager:(RKObjectManager*)manager
{
    if ( self = [super init] ) {
        
        _manager  = manager;
        _mappings = mappings;
        _paths    = paths;
        
        
        //set the mapping for the resource and resources path
        [manager.mappingProvider setObjectMapping:mappings.deserializer forResourcePathPattern:_router.resourcePath];
        [manager.mappingProvider setObjectMapping:mappings.deserializer forKeyPath:router.resource.resourcePluralName];
        
        //associated  the entity class to a resource pattern
        //[manager.router routeClass:mapping.objectClass toResourcePathPattern:_router.resourcePath];
    }
    
    return self;
}

- (void)loadWithQueryDictionary:(NSDictionary*)dictionary loader:(void (^)(RKObjectLoader *loader))loader
{
    RKObjectLoader *objectLoader = [self loaderWithQueryDictionary:dictionary];
    loader(objectLoader);
    [objectLoader send];
}

- (RKObjectLoader*)loaderWithQueryDictionary:(NSDictionary*)dictionary
{
    NSString *resourcePath = [self.router resourcePathWithQueryDictionary:dictionary];
    return [self.manager loaderWithResourcePath:resourcePath];
}

- (RKObjectLoader*)loaderForObject:(id)object
{
    NSString *resourcePath = [self.router resourcePathForObject:object];
    RKObjectLoader *loader = [self.manager loaderWithResourcePath:resourcePath];
    return loader;
}

- (void)loadWithId:(NSUInteger)id loader:(void (^)(RKObjectLoader *loader))loader
{
    NSDictionary *query = [NSDictionary dictionaryWithKeysAndObjects:@"id",
                           [NSString stringWithFormat:@"%d", id], nil];
    
    [self loadWithQueryDictionary:query loader:loader];
}

- (void)loadListWithQueryDictionary:(NSDictionary*)dictionary loader:(void (^)(RKObjectLoader *loader))loader
{
    RKObjectLoader *objectLoader = [self listLoaderWithQueryDictionary:dictionary];
    loader(objectLoader);
    [objectLoader send];
}

- (RKObjectLoader*)listLoaderWithQueryDictionary:(NSDictionary *)dictionary
{
    NSString *path =[self.router resourcesPathWithQueryDictionary:dictionary];
    return [self.manager loaderWithResourcePath:path];
}


- (RKObjectPaginator*)paginator
{
    NSString *path = [[self.router resourcesPath] stringByAppendingString:@"?limit=:perPage&offset=:currentPage"];
    RKObjectPaginator *paginator = [self.manager paginatorWithResourcePathPattern:path];
    return paginator;
}

@end