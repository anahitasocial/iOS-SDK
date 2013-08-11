//
//  AKEntityConfiguration.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKRestKit.h"

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
    NSString *pattern = self.pathPatternForGettingPaginatedCollection;
    
    if ( parameters ) {
        pattern = [pattern stringByAppendingDictionaryQueryParamaters:parameters];
    }
    
    return [self.objectManager paginatorWithPathPattern:pattern];
}

- (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure
{

    [self.objectManager getObjectsAtPath:self.pathPatternForGettingCollection parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];    
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
        _mappingForRequest = [self.mappingForResponse inverseMapping];
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

- (NSString*)pathPatternForGettingPaginatedCollection
{
    if ( !_pathPatternForGettingPaginatedCollection
        && self.pathPatternForGettingCollection
      ) {
        _pathPatternForGettingPaginatedCollection = [self.pathPatternForGettingCollection
                stringByAppendingString:@"?limit=:perPage&start=:offset"];
    }
    return _pathPatternForGettingPaginatedCollection;
}

@end
