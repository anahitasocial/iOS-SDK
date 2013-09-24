//
//  AKEntity.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKEntityObject.h"
#import "RestKit.h"

#import "NSString+NimbusCore.h"
#import "NSString+AKCore.h"

#import <objc/runtime.h>

@implementation AKQueryObject

+ (id)queryUsingBlock:(void(^)(id query))block
{
    AKQueryObject *query = [self new];
    block(query);
    return query;
}

- (id)init
{
    if ( self = [super init] ) {
        _querySerializer = [RKObjectMapping mappingForClass:[self class]];
    }    
    return self;
}

- (NSDictionary*)serializedValues
{
    RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:self mapping:_querySerializer];
    NSDictionary *dict = [serializer serializedObject:nil];
    return dict;
}

- (NSString*)description
{
    return [self.serializedValues description];
}

@end

@interface AKEntityObject()

@property(nonatomic,strong) id loaderDelegates;

@end

@implementation AKEntityObject
{
    NSMutableDictionary *_objectData;
}

#pragma mark - 
#pragma mark Initializations

- (id)init
{
    if ( self = [super init] ) {
        _objectData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithValues:(NSDictionary*)values
{
    if ( self = [self init] ) {
        __block id object = self;
        [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [object setValue:obj forKey:key];
        }];
    }
    return self;
}

+ (id)objectWithValues:(NSDictionary *)values
{
    return [[self alloc] initWithValues:values];
}

+ (id)objectWithId:(NSUInteger)objectId
{
    return [[self alloc] initWithId:objectId];
}

- (id)initWithId:(NSUInteger)identifier;
{
    if ( self = [self init] ) {
        _identifier = [NSNumber numberWithInt:identifier];
    }
    return self;
}

- (id)initWithBlock:(void(^)(id entity))block
{
    if ( self = [self init] ) {
        block(self);
    }
    return self;
}

+ (id)initWithBlock:(void(^)(id object))block
{
    return [[self alloc] initWithBlock:block];
}

#pragma mark - 
#pragma mark - Loading collection

+ (RKObjectLoader*)loaderWithQuery:(id)query
{
    NSString *resourcePath = [self sharedConfiguration].collectionResourcePath;
    if ( query == nil )
        query = [NSDictionary dictionary];
    else if ( [query isKindOfClass:[AKQueryObject class]] )
        query = [query serializedValues];
    else if ( [query isKindOfClass:[NSString class]])
        query = [query queryParameters];
    
    resourcePath = [resourcePath stringByAddingQueryDictionary:query];  
    RKObjectLoader *loader = [[self sharedConfiguration].objectManager loaderWithResourcePath:resourcePath];
    loader.objectMapping  = [self sharedConfiguration].collectionMapping;
    return loader;
}

+ (RKObjectPaginator*)paginatorWithQuery:(id)query
{
    NSString *resourcePath = [self sharedConfiguration].collectionResourcePath;

    if ( query == nil )
        query = [NSDictionary dictionary];
    else if ( [query isKindOfClass:[AKQueryObject class]] )
        query = [query serializedValues];
    else if ( [query isKindOfClass:[NSString class]])
        query = [query queryParameters];
    
    resourcePath = [resourcePath stringByAppendingDictionaryQueryParamaters:query];
    RKObjectPaginator *paginator = [self.sharedConfiguration.objectManager paginatorWithResourcePathPattern:resourcePath];
    paginator.objectMapping = [self sharedConfiguration].collectionMapping;
    return paginator;
}

#pragma mark - 
#pragma mark Entity Configuration

+ (AKEntityConfiguration*)sharedConfiguration
{
    static NSMutableDictionary *configurations;
    if ( !configurations ) { configurations = [NSMutableDictionary dictionary]; }
    NSString *class = NSStringFromClass([self class]);
    if ( ![configurations valueForKey:class] )
    {
        @synchronized(configurations)
        {
            AKEntityConfiguration *configuration = [[AKEntityConfiguration alloc]
                                                    initWithObjectClass:[self class]];
            
            [self configureObjectEntity:configuration];

            [configuration.objectManager.router routeClass:configuration.objectClass
                                      toResourcePathPattern:configuration.itemResourcePath];
            
            [configuration.objectManager.mappingProvider
             setObjectMapping:configuration.collectionMapping
             forResourcePathPattern:configuration.collectionResourcePath];
            
            
            [configuration.objectManager.mappingProvider
             setObjectMapping:configuration.objectMapping
             forResourcePathPattern:configuration.itemResourcePath];
            
            [configuration.objectManager.mappingProvider setSerializationMapping:configuration.objectSerializer forClass:[self class]];
            
            [configurations setValue:configuration
                              forKey:class];
        }
    }
    return [configurations valueForKey:class];
}

+ (void)configureObjectEntity:(AKEntityConfiguration*)configuration
{
    [configuration.objectMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    
    [configuration.objectMapping mapAttributes:@"commands", nil];
        
}

#pragma mark -
#pragma mark Class methods

- (AKEntityConfiguration*)sharedConfiguration
{
    return [[self class] sharedConfiguration];
}

#pragma mark -
#pragma mark Object loading

- (NSString*)resourcePath
{
    return [self.sharedConfiguration.objectManager.router resourcePathForObject:self method:RKRequestMethodGET];
}

- (RKObjectLoader*)objectLoader
{
    return [self.sharedConfiguration.objectManager
            loaderForObject:self method:RKRequestMethodGET];
}

- (void)loadWithBlock:(void (^)(RKObjectLoader*loader))block
{
    RKObjectLoader *loader = [self.sharedConfiguration.objectManager
                              loaderForObject:self method:RKRequestMethodGET];
    

    loader.objectMapping    = self.sharedConfiguration.objectMapping;
    loader.targetObject     = self;
    block(loader);
    self.loaderDelegates =  [[self.sharedConfiguration.delegateProxyClass alloc] initWithObjects:self,loader.delegate, nil];
    loader.delegate  = self.loaderDelegates;
    [loader send];
}

- (void)loadWithDelegate:(id<RKObjectLoaderDelegate>)delegate
{
    [self loadWithBlock:^(RKObjectLoader *loader) {
        loader.delegate = delegate;
    }];
}

- (BOOL)load:(__autoreleasing NSError**)error
{
    __block BOOL success = NO;
    AKNonBlockThreadStopper *stopper = [AKNonBlockThreadStopper stopperForCurrentThread];
    [self loadWithBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object) {
            success = YES;
            [stopper resume];
        };
        loader.onDidFailWithError = ^(NSError *err) {
            *error = err;
            [stopper resume];
        };
    }];
    [stopper wait];
    return success;
}

- (BOOL)load
{
    return [self load:nil];
}

#pragma mark -
#pragma mark Object saving

- (BOOL)save
{
    return [self save:nil];
}

- (BOOL)save:(NSError * __autoreleasing *)error
{
    AKNonBlockThreadStopper *stopper = [AKNonBlockThreadStopper stopperForCurrentThread];
    __block BOOL success = NO;
    [self saveWithBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            if ( response.isSuccessful ) {
                success = YES;
            }
            [stopper resume];
        };
        loader.onDidFailWithError = ^(NSError *err) {
            //*error = err;
            [stopper resume];
        };
    }];
    [stopper wait];
    return success;
}

- (void)delete:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    RKObjectLoader *loader =
        [self.sharedConfiguration.objectManager loaderForObject:self method:RKRequestMethodGET];
 
    loader.method  = RKRequestMethodDELETE;
    loader.sourceObject = self;
    loader.onDidLoadResponse = ^(RKResponse *response) {
        if ( response.isSuccessful && onSuccess )
            onSuccess();
    };
    loader.onDidFailWithError = onFailure;
    loader.delegate  = self;
    [loader send];
}

- (void)saveWithBlock:(void (^)(RKObjectLoader*loader))block
{
    RKObjectLoader *loader = nil;
    
    //if entityId is valid then
    if ( self.identifier > 0 ) {
        loader = [self.sharedConfiguration.objectManager loaderForObject:self method:RKRequestMethodGET];
    } else {
        //get a loader for the collection
        loader = [self.sharedConfiguration.objectManager loaderWithResourcePath:self.sharedConfiguration.collectionResourcePath];
    }
    
    loader.method  = RKRequestMethodPOST;
    loader.sourceObject  = self;
    loader.objectMapping = self.sharedConfiguration.objectMapping;
    //@TODO any reaons we are passing here. shouldn't that be part of hte object managaer
    //mapping provider
    loader.serializationMapping = self.sharedConfiguration.objectSerializer;
    loader.targetObject = self;
    NSError *error = nil;
    //lets handle our own serialization that way we can handle
    //NSData as attachement
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:[[RKObjectSerializer serializerWithObject:self mapping:loader.serializationMapping] serializedObject:&error]];
    [dictionary addEntriesFromDictionary:_objectData];
    RKParams *param = [RKParams params];
    //@TODO a bug that prevents storing when using multi-part
    //for regular post, so lets use multi-part only for when there's a
    //multi-part data
    __block BOOL hasAttachement = NO;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ( [obj isKindOfClass:[AKParamData class]] ) {
            hasAttachement = YES;
            AKParamData *paramData = (AKParamData*)obj;
            RKParamsAttachment *attachement = [param setData:paramData.data MIMEType:paramData.MIMEType forParam:key];
            if ( NULL != paramData.fileName )
                attachement.fileName = paramData.fileName;
        }
        else {
            [param setValue:obj forParam:key];
        }
    }];
    loader.params = hasAttachement ? param : dictionary;
    block(loader);
    self.loaderDelegates =  [[self.sharedConfiguration.delegateProxyClass alloc] initWithObjectEntity:self objectLoaderDelegate:loader.delegate];
    loader.delegate  = self.loaderDelegates;
    [loader send];
}

- (void)saveWithDelegate:(id<RKObjectLoaderDelegate>)delegate
{
    [self saveWithBlock:^(RKObjectLoader *loader) {
        loader.delegate = delegate;
    }];
}

#pragma mark -
#pragma mark Validation

- (BOOL)validateValuesForKeys:(NSArray*)keys error:(NSError**)error;
{
    BOOL ret = YES;
    //validate all the seriaializable properties
    //AKObjectRepository *repository = [[self class] sharedRepository];
    //NSArray *keys        = [repository.mappings.serializer.mappings valueForKey:@"sourceKeyPath"];
    NSDictionary *values = [self dictionaryWithValuesForKeys:keys];
    for(NSString *key in keys) {
        id value = [values valueForKey:key];
        ret = [self validateValue:&value forKey:key error:error];
        if ( NO == ret ) {
            break;
        }
    }
    return ret;
}

#pragma mark -
#pragma mark NSKeyValueCoding

- (id)valueForUndefinedKey:(NSString *)key
{
    return [_objectData valueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ( value == NULL )
        value = [NSNull null];
    
    [_objectData setValue:value forKey:key];
}

- (NSString *)description
{
    NSArray *keys = [self.sharedConfiguration.objectMapping.mappings valueForKey:@"destinationKeyPath"];
    NSDictionary *values = [self dictionaryWithValuesForKeys:keys];
    return [values description];
}

#pragma mark -
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NSArray *keys = [self.sharedConfiguration.objectMapping.mappings valueForKey:@"destinationKeyPath"];
    NSDictionary *values = [self dictionaryWithValuesForKeys:keys];
    id copy = [[[self class] allocWithZone:zone] init];
    [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [copy setValue:obj forKey:key];
    }];
    
    return copy;
}
            
@end