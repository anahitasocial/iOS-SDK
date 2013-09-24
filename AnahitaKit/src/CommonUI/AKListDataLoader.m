//
//  AKListDataLoader.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKCommonUI.h"
#import "RestKit.h"

@interface AKListDataLoader_Entity : AKListDataLoader

- (id)initEntityManager:(AKEntityManager*)entityManager
        path:(NSString*)path
        parameters:(NSDictionary*)parameters
        paginate:(BOOL)paginate
        ;

@end


@interface AKListDataLoader_Array : AKListDataLoader

- (id)initWithArray:(NSArray*)array;

@end

@interface AKListDataLoader()

@property (nonatomic, strong, readwrite) NSMutableArray *objects;
@property (nonatomic, copy) void (^successBlock)(NSArray *objects, NSUInteger page);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

@end

#pragma mark -
#pragma mark - AKListDataLoader_Array

@implementation AKListDataLoader

@dynamic canLoadMoreData;
@dynamic parameters;

+ (instancetype)dataLoaderFromArray:(NSArray *)data
{
    return [[AKListDataLoader_Array alloc] initWithArray:data];
}

+ (instancetype)dataLoaderFromEntityManager:(AKEntityManager*)entityManager
        path:(NSString*)path
        parameters:(NSDictionary*)parameters
        paginate:(BOOL)paginate
{
    return [[AKListDataLoader_Entity alloc] initEntityManager:entityManager path:path parameters:parameters paginate:paginate];
}

- (id)init
{
    if ( self = [super init] ) {        
        _objects = [NSMutableArray array];
    }    
    return self;
}

- (void)setCompletionBlockWithSuccess:(void (^)(NSArray *objects, NSUInteger page))success
                              failure:(void (^)(NSError *error))failure
{
    self.successBlock = success;
    self.failureBlock = failure;
}

- (void)loadMoreData
{
    [NSException raise:@"Can't use this method" format:@""];
}

- (void)loadData
{
    [self loadDataWithParams:nil];
}

- (void)loadDataWithAdditionalParams:(NSDictionary *)parameters
{
    [self loadDataWithParams:nil];
}

- (void)loadDataWithParams:(NSDictionary *)parameters
{
    [NSException raise:@"Can't use this method" format:@""];
}

- (NSArray*)objects
{
    return _objects;
}

@end

#pragma mark -
#pragma mark AKListDataLoader_Array

@implementation NSArray(AKDataLoader)

- (AKListDataLoader*)dataLoader {
    return [AKListDataLoader dataLoaderFromArray:self];
}

@end

@implementation AKListDataLoader_Array
{
    NSArray *_originalArray;
}
- (id)initWithArray:(NSArray *)array
{
    if ( self = [super init] ) {
        _originalArray = array;
        [_objects addObjectsFromArray:array];        
    }    
    return self;
}

- (BOOL)canLoadMoreData
{
    return NO;
}

- (void)loadData
{
    if ( self.successBlock ) {
        self.successBlock(self.objects, 0);
    }
    
    if ([self.delegate respondsToSelector:@selector(listLoader:didLoadObjects:forPage:)]) {
        [self.delegate listLoader:self didLoadObjects:_originalArray forPage:0];
    }    
}

@end

#pragma mark -

@interface RKPaginator()

@property (nonatomic, strong) RKObjectRequestOperation *objectRequestOperation;

@end

#pragma mark -
#pragma mark AKListDataLoader_Entity

@implementation AKEntity(AKDataLoader)

+ (AKListDataLoader*)dataLoaderFromPath:(NSString*)path parameters:(NSDictionary*)parameter paginate:(BOOL)paginate
{
    return [AKListDataLoader dataLoaderFromEntityManager:[self sharedManager] path:path parameters:parameter paginate:paginate];
}

+ (AKListDataLoader*)dataLoaderPaginate:(BOOL)paginate
{
    return [self dataLoaderWithParameters:nil paginate:paginate];
}

+ (AKListDataLoader*)dataLoaderWithParameters:(NSDictionary*)parameters paginate:(BOOL)paginate
{
    return [self dataLoaderFromPath:nil parameters:parameters paginate:paginate];
}

@end

@implementation AKListDataLoader_Entity
{
    BOOL _paginate;
    AKEntityManager *_entityManager;
    NSDictionary    *_baseParameters;
    NSMutableDictionary    *_parameters;
    RKPaginator     *_paginator;
    NSString *_path;
}

- (id)initEntityManager:(AKEntityManager*)entityManager
        path:path
        parameters:(NSDictionary*)parameters
        paginate:(BOOL)paginate


{
    if ( self = [super init] ) {
        _entityManager     = entityManager;
        _baseParameters    = parameters;
        _paginate          = paginate;
        _path              = path;
        _parameters        = [NSMutableDictionary dictionaryWithDictionary:_baseParameters];
    }
    
    return self;
}

- (void)loadMoreData
{ 
    NSAssert(_paginator, @"Pagniator is null");
    [self willLoadObjectsForPage:_paginator.currentPage + 1];
    [_paginator loadNextPage];
}

- (BOOL)canLoadMoreData
{
    if ( _paginator && _paginator.objectRequestOperation == NULL) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadData
{
    return [self loadDataWithParams:nil];
}

- (void)loadDataWithAdditionalParams:(NSDictionary*)additionalParams
{
    //whatever the existing params are keep them
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [params addEntriesFromDictionary:additionalParams];
    [self loadDataWithParams:params];
}

- (void)loadDataWithParams:(NSDictionary*)parameters
{
    [_objects removeAllObjects];
    
    //reset the params with base params
    _parameters = [NSMutableDictionary dictionaryWithDictionary:_baseParameters];   
    
    if ( parameters ) {
        [_parameters addEntriesFromDictionary:parameters];
    }
        
    __weak__(self);
    
    [self willLoadObjectsForPage:0];
    
    if ( _paginate ) { 
        _paginator = [_entityManager paginatorWithPath:_path paramaters:_parameters];
        [_paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            [weakself didLoadObjects:objects forPage:page];
        } failure:^(RKPaginator *paginator, NSError *error) {
            [weakself didFailWithError:error];
        }];
        [_paginator loadPage:0];
    } else {
        [_entityManager objectsWithPath:_path parameters:_parameters success:^(NSArray *objects) {
                [weakself didLoadObjects:objects forPage:0];
        } failure:^(NSError *error) {[weakself didFailWithError:error];}];
    }
}

- (NSDictionary*)parameters
{
    return _parameters;
}

- (void)willLoadObjectsForPage:(NSUInteger)page
{
    if ( [self.delegate respondsToSelector:@selector(listLoader:willLoadObjectsForPage:)] ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate listLoader:self willLoadObjectsForPage:page];
        });
    }
}

- (void)didLoadObjects:(NSArray*)objects forPage:(NSInteger)page
{
    [self.objects addObjectsFromArray:objects];
    if ( self.successBlock ) {
        self.successBlock(objects, page);
    }
    if ([self.delegate respondsToSelector:@selector(listLoader:didLoadObjects:forPage:)]) {
        [self.delegate listLoader:self didLoadObjects:objects forPage:page];
    }
}

- (void)didFailWithError:(NSError*)error 
{
    if ( self.failureBlock ) {
        self.failureBlock(error);
    }
    
    if ( [self.delegate respondsToSelector:@selector(listLoader:didFail:)]) {
        [self.delegate listLoader:self didFail:error];
    }
}

@end