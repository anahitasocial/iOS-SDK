//
//  AKEntity.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-11.
//
//


@class AKEntityManager;
@class RKPaginator;
@class RKObjectManager;
@class RKObjectMapping;
@class RKResponseDescriptor;

/**
 @class AKEntity
 
 @abstract
*/
@interface AKEntity : NSObject
{
    NSMutableDictionary *_params;
}

/**
 @method
 
 @abstract
 
*/
+ (void)setSharedManager:(AKEntityManager*)configuration;

/**
 @method
 
 @abstract
 
*/
+ (AKEntityManager*)sharedManager;

/**
 @method
 
 @abstract
 
*/
+ (void)configureEntity:(AKEntityManager *)manager;

/**
 @method
 
 @abstract
 
*/
+ (RKPaginator*)paginatorWithParameters:(NSDictionary*)parameters;

/**
 @method
 
 @abstract
 
*/
+ (RKPaginator*)paginatorWithPath:(NSString*)path parameters:(NSDictionary*)parameters;

/**
 @method
 
 @abstract
 
*/
+ (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure;

/**
 @method
 
 @abstract
 
*/
+ (void)objectsFromPath:(NSString*)path parameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure;

/**
 @method
 
 @abstract
 
*/
- (void)load:(void(^)())success failure:(void(^)(NSError *error))failure;

/** @abstract */
@property(nonatomic,assign,getter=isLoaded) BOOL loaded;

/** @abstract */
@property(nonatomic,readonly) NSString* resourcePath;

/** @abstract */
@property(nonatomic,readonly) RKObjectManager *objectManager;

/**
 @method
 
 @abstract
 
*/
- (void)save:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 @method
 
 @abstract
 
*/
- (void)post:(NSDictionary*)parameters success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 @method
 
 @abstract
 
*/
- (void)delete:(void(^)())success failure:(void(^)(NSError *error))failure;

@end

