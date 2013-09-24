//
//  AKEntity.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-11.
//
//

#import "AKRestKit.h"
#import <objc/runtime.h>
#import "SOCKit.h"

static NSMutableDictionary *sharedConfigurations;

@implementation AKEntity

+ (RKPaginator*)paginatorWithParameters:(NSDictionary*)parameters
{
    return [self.sharedManager paginatorWithParamaters:parameters];
}

+ (RKPaginator*)paginatorWithPath:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self.sharedManager paginatorWithPath:path paramaters:parameters];
}

+ (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure
{
    [self.sharedManager objectsWithParameters:parameters success:success failure:failure];
}

+ (void)objectsFromPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure

{
    [self.sharedManager objectsWithPath:path parameters:parameters success:success failure:failure];
}

#pragma mark -
#pragma mark - Entity Configuration

+ (void)configureEntity:(AKEntityManager *)manager
{
    
}

+ (NSMutableDictionary*)sharedConfigurations
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfigurations = [NSMutableDictionary dictionary];
    });
    return sharedConfigurations;
}

+ (void)setSharedManager:(AKEntityManager*)configuration
{
    @synchronized(sharedConfigurations) {
        [sharedConfigurations setValue:configuration forKey:NSStringFromClass(self)];
    }
}

+ (AKEntityManager *)sharedManager
{
    @synchronized(sharedConfigurations) {
        AKEntityManager *manager = [[self sharedConfigurations] valueForKey:NSStringFromClass(self)];
        if ( !manager ) {
            NSString *className = [NSStringFromClass(self) stringByAppendingString:@"Manager"];
            Class managerClass = NSClassFromString(className);
            if ( !managerClass ) {
                managerClass = [AKEntityManager class];
            }
            
            manager = [[managerClass alloc] initForClass:self];
            manager.objectManager = [RKObjectManager sharedManager];

            [self configureEntity:manager];
            
            NSAssert(manager.pathPatternForGettingCollection, @"No path specified for getting colllection");
            NSAssert(manager.pathPatternForGettingEntity, @"No path specified for getting entity");

            //add descriptors to the object manager
            [manager.objectManager addResponseDescriptorsFromArray:manager.responseDescriptorsForCollection];
            [manager.objectManager addResponseDescriptorsFromArray:manager.responseDescriptorsForEntity];
            [manager.objectManager addRequestDescriptor:[RKRequestDescriptor
            requestDescriptorWithMapping:manager.mappingForRequest objectClass:[self class] rootKeyPath:NULL method:RKRequestMethodAny]];
            
            //add router to the object manager
            [manager.objectManager.router.routeSet
                addRoute:[RKRoute routeWithClass:self pathPattern:manager.pathPatternForGettingEntity method:RKRequestMethodAny]];
            
            [self setSharedManager:manager];
        }

        return manager;
    }
}

- (id)init
{
    if ( self = [super init] ) {
        //per class called the sharedManager once
        //to instantiate it's configuration
        [[self class] sharedManager];
        _params = [NSMutableDictionary new];
        _loaded = NO;
    }
    return self;
}

#pragma mark -
#pragma mark - Entity Loading

- (void)load:(void(^)())success failure:(void(^)(NSError *error))failure
{
    AKEntityManager *configuration = [[self class] sharedManager];   
    
    if ( self.isLoaded )
    {
        //if already loaded then don't load
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityWillLoadNotification object:self]];
        });
        
        [configuration.objectManager getObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _loaded = YES;
            success();
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityDidLoadNotification object:self]];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            if ( failure != nil )
                failure(error);
        }];
    }
}

- (void)post:(NSDictionary*)parameters success:(void(^)())success failure:(void(^)(NSError *error))failure
{    
    [[RKObjectManager sharedManager] postObject:nil path:self.resourcePath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];    
}

- (void)save:(void(^)())success failure:(void(^)(NSError *error))failure
{
    AKEntityManager *configuration = [[self class] sharedManager];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityWillSaveNotification object:self]];
    });
    [configuration.objectManager postObject:self path:nil parameters:_params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityDidSaveNotification object:self]];
        [_params removeAllObjects];        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if ( failure != nil )
            failure(error);
    }];
}

- (void)delete:(void(^)())success failure:(void(^)(NSError *error))failure
{
    AKEntityManager *configuration = [[self class] sharedManager];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityWillDeleteNotification object:self]];
    });
    [configuration.objectManager deleteObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAKEntityDidDeleteNotification object:self]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if ( failure != nil )
            failure(error);
    }];
}

- (RKObjectManager*)objectManager
{
    return [[self class] sharedManager].objectManager;
}

- (NSString*)resourcePath
{
    NSString *entityPath = [[self class] sharedManager].pathPatternForGettingEntity;
    entityPath = [[SOCPattern patternWithString:entityPath] stringFromObject:self];
    return entityPath;
}

#pragma mark 

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ( value == NULL )
        value = [NSNull null];
    
    [_params setValue:value forKey:key];
}

@end

