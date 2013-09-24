//
//  AKEntityConfiguration.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKRestKit.h"

NSString *const kAKEntityWillLoadNotification = @"kAKEntityWillLoadNotification";
NSString *const kAKEntityDidLoadNotification = @"kAKEntityDidLoadNotification";
NSString *const kAKEntityWillSaveNotification = @"kAKEntityWillSaveNotification";
NSString *const kAKEntityDidSaveNotification = @"kAKEntityDidSaveNotification";
NSString *const kAKEntityWillDeleteNotification = @"kAKEntityWillDeleteNotification";
NSString *const kAKEntityDidDeleteNotification  = @"kAKEntityDidDeleteNotification";


@implementation AKEntityManager

- (id)initForClass:(Class)entityClass
{
    if ( self = [super init] ) {
        _entityClass = entityClass;
    }
    
    return self;
} 

- (RKPaginator*)paginatorWithParamaters:(NSDictionary*)parameters
{
    return [self paginatorWithPath:self.pathPatternForGettingCollection paramaters:parameters];
}

- (RKPaginator*)paginatorWithPath:(NSString *)path paramaters:(NSDictionary *)parameters
{ 
    if ( !path ) path = self.pathPatternForGettingCollection;
    
    if ( ![path isEqualToString:self.pathPatternForGettingCollection] )
    {
        NSArray *descriptors = [self.objectManager.responseDescriptors arrayByFilteringObjectsUsingBlock:^BOOL(RKResponseDescriptor *responseDescriptor, NSUInteger idx) {
            return responseDescriptor.pathPattern &&
                [responseDescriptor matchesPath:path] && (RKRequestMethodGET & responseDescriptor.method);
        }];
        
        if ( descriptors.count == 0 )
        {
            [self.objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.mappingForResponse method:RKRequestMethodGET pathPattern:path keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        }
    }
    
    if ( parameters ) {
        path = [path stringByAppendingDictionaryQueryParamaters:parameters];
    }
     
    return [self.objectManager paginatorWithPathPattern:[self paginatedColllectionPathFromPath:path]];
}

- (void)objectsWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    if ( !path ) path = self.pathPatternForGettingCollection;
    NSArray *descriptors = [self.objectManager.responseDescriptors arrayByFilteringObjectsUsingBlock:^BOOL(RKResponseDescriptor *responseDescriptor, NSUInteger idx) {
        return responseDescriptor.pathPattern &&
            [responseDescriptor matchesPath:path] && (RKRequestMethodGET & responseDescriptor.method);
    }];
    
    if ( descriptors.count == 0 )
    {
        [self.objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.mappingForResponse method:RKRequestMethodGET pathPattern:path keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    }
    
    
    [self.objectManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];  
}

- (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure
{
    [self objectsWithPath:self.pathPatternForGettingCollection parameters:parameters success:success failure:failure];
}

- (RKObjectMapping*)mappingForResponse
{
    if ( !_mappingForResponse ) {
        _mappingForResponse = [RKObjectMapping mappingForClass:_entityClass];        
    }    
    return _mappingForResponse;
}

- (RKObjectMapping*)mappingForRequest
{
    if ( !_mappingForRequest ) {
        _mappingForRequest = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    }    
    return _mappingForRequest;
}

- (NSArray*)responseDescriptorsForCollection
{
    if ( _responseDescriptorsForCollection.count < 1
            && self.pathPatternForGettingCollection
            && self.mappingForResponse
            ) {
        
        _responseDescriptorsForCollection = @[[RKResponseDescriptor
            responseDescriptorWithMapping:self.mappingForResponse pathPattern:self.pathPatternForGettingCollection keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    }
    
    return _responseDescriptorsForCollection;
}

- (NSArray*)responseDescriptorsForEntity
{
    if ( _responseDescriptorsForEntity.count < 1
            && self.pathPatternForGettingEntity
            && self.mappingForResponse
            ) {
        
        _responseDescriptorsForEntity = @[[RKResponseDescriptor
            responseDescriptorWithMapping:self.mappingForResponse pathPattern:self.pathPatternForGettingEntity keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    }
    
    return _responseDescriptorsForEntity;
}

- (NSString *)paginatedColllectionPathFromPath:(NSString*)path
{
    return [path stringByAppendingStringQueryParamaters:@"limit=:perPage&start=:offset"];
}

@end
