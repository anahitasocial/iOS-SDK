//
//  AKObjectResourceRouter.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "NSString+NimbusCore.h"

@implementation AKObjectResourceRouter

- (id)initWithObjectResource:(AKObjectResourcePaths *)resource
{
    return [self initWithObjectResource:resource prefixPath:resource.resourcePluralName];
}

- (id)initWithObjectResource:(AKObjectResourcePaths *)resource prefixPath:(NSString *)prefixPath
{
    NSString *resourcePath  = [NSString stringWithFormat:@"/%@/%@", prefixPath,resource.resourceName];
    NSString *resourcesPath = [NSString stringWithFormat:@"/%@/%@", prefixPath,resource.resourcePluralName];
    return [self initWithObjectResource:resource resourceBasePath:resourcePath resourcesBasePath:resourcesPath];
}

- (id)initWithObjectResource:(AKObjectResourcePaths *)resource resourceBasePath:(NSString *)resourcePath resourcesBasePath:(NSString *)resourcesPath
{
    if ( self = [super init] )
    {
        _resource      = resource;
        _resourcePath  = resourcePath;
        _resourcesPath = resourcesPath;
    }
    
    return self;
}

- (NSString*)resourcePathWithQueryDictionary:(NSDictionary *)dictionary
{
    return [_resourcePath stringByAddingQueryDictionary:dictionary];
}

- (NSString*)resourcesPathWithQueryDictionary:(NSDictionary *)dictionary
{
    return [_resourcesPath stringByAddingQueryDictionary:dictionary];
}

- (NSString*)resourcePathForObject:(id)object
{
    NSDictionary *dict = [NSDictionary dictionary];
    
    if ( [object valueForKey:@"entityId"] ) {
        dict = [NSDictionary dictionaryWithObject:[[object entityId] stringValue] forKey:@"id"];
    }
    return [self resourcePathWithQueryDictionary:dict];
}

@end
