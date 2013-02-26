//
//  AKListDataLoader.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

@class AKListDataLoader;

/**
 @protocol AKListDataLoader
 
 @abstract
*/
@protocol AKListDataLoaderDelegate <NSObject>

@optional

/**
 @method
 
 @abstract
 
*/
- (void)listLoader:(AKListDataLoader*)listLoader willLoadObjectsForPage:(NSUInteger)page;

/**
 @method
 
 @abstract
 
*/
- (void)listLoader:(AKListDataLoader *)listLoader didLoadObjects:(NSArray*)objects forPage:(NSUInteger)page;

/**
 @method
 
 @abstract
 
*/
- (void)listLoader:(AKListDataLoader *)listLoader didFail:(NSError*)error;

@end

/**
 @protocol AKListDataLoader
 
 @abstract
*/
@protocol AKListDataLoader <NSObject>

@required


/**
 @method
 
 @abstract
 
*/
- (void)loadData;

/**
 @method
 
 @abstract
 
*/
- (void)loadDataWithParams:(NSDictionary*)parameters;

/**
 @method
 
 @abstract
 
*/
- (void)loadDataWithAdditionalParams:(NSDictionary*)parameters;

/**
 @method
 
 @abstract
*/
- (void)setCompletionBlockWithSuccess:(void (^)(NSArray *objects, NSUInteger page))success
                              failure:(void (^)(NSError *error))failure;


/** @abstract */
@property(nonatomic,strong,readonly) NSArray* objects;

/** @abstract */
@property(nonatomic,assign,readonly) BOOL canLoadMoreData;

/** @abstract */
@property(nonatomic,readonly) NSDictionary* parameters;

/** @abstract */
@property (nonatomic,assign) id<AKListDataLoaderDelegate> delegate;

/**
 @method
 
 @abstract
 
*/
- (void)loadMoreData;

@end

/**
 @class AKListDataLoader
 
 @abstract
*/
@interface AKListDataLoader : NSObject <AKListDataLoader>
{
    @protected
    
    //the objects in the data loader so far
    NSMutableArray *_objects;
}

@property (nonatomic, assign) id<AKListDataLoaderDelegate> delegate;

/**
 @method
 
 @abstract
 
*/
+ (instancetype)dataLoaderFromArray:(NSArray*)data;

/**
 @method
 
 @abstract
 
*/
+ (instancetype)dataLoaderFromEntityManager:(AKEntityManager*)entityManager
        parameters:(NSDictionary*)parameters
        paginate:(BOOL)paginate
        ;

@end


/**
 @category 
 
 @abstract 
*/
@interface NSArray (AKDataLoader)

/**
 @method
 
 @abstract
*/
- (AKListDataLoader*)dataLoader;

@end

@interface AKEntity (AKDataLoader)


/**
 @method
 
 @abstract
 
*/
+ (AKListDataLoader*)dataLoaderPaginate:(BOOL)paginate;

/**
 @method
 
 @abstract
 
*/
+ (AKListDataLoader*)dataLoaderWithParameters:(NSDictionary*)parameters paginate:(BOOL)paginate;

@end