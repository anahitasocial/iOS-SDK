//
//  AKEntityConfiguration.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

@class RKObjectManager;
@class RKObjectMapping;
@class RKPaginator;

/**
 @class AKEntityConfiguration
 
 @abstract
*/
@interface AKEntityManager : NSObject
{
    Class _entityClass;
}

/**
 @method

 @abstract
*/
- (id)initForClass:(Class)entityClass;

/**
 @method

 @abstract
*/
- (RKPaginator*)paginatorWithParamaters:(NSDictionary*)parameters;

/**
 @method

 @abstract
*/
- (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure;

/** @abstract **/
@property (nonatomic, strong) RKObjectMapping *mappingForResponse;

/** @abstract **/
@property (nonatomic, strong) RKObjectManager *objectManager;

/** @abstract **/
@property (nonatomic, copy) NSString *pathPatternForGettingPaginatedCollection;

/** @abstract **/
@property (nonatomic, copy) NSString *pathPatternForGettingCollection;

/** @abstract **/
@property (nonatomic, copy) NSString *pathPatternForGettingEntity;

/** @abstract **/
@property (nonatomic, strong) NSArray *responseDescriptorsForEntity;

/** @abstract **/
@property (nonatomic, strong) NSArray *responseDescriptorsForCollection;

@end