//
//  AKEntity.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-11.
//
//

#import "AKRestKit.h"
#import <objc/runtime.h>

static NSMutableDictionary *sharedConfigurations;

@implementation AKEntity

+ (RKPaginator*)paginatorWithParameters:(NSDictionary*)parameters
{
    return [self.sharedManager paginatorWithParamaters:parameters];
}

+ (void)objectsWithParameters:(NSDictionary*)parameters success:(void(^)(NSArray *objects))success
    failure:(void(^)(NSError *error))failure
{
    [self.sharedManager objectsWithParameters:parameters success:success failure:failure];
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
            
            //add descriptors to the object manager
            [manager.objectManager addResponseDescriptorsFromArray:manager.responseDescriptorsForCollection];
            [manager.objectManager addResponseDescriptorsFromArray:manager.responseDescriptorsForEntity];
            
            //add router to the object manager
            [manager.objectManager.router.routeSet
                addRoute:[RKRoute routeWithClass:self pathPattern:manager.pathPatternForGettingEntity method:RKRequestMethodGET]];
            
            [self setSharedManager:manager];
        }

        return manager;
    }
}

#pragma mark -
#pragma mark - Entity Loading

- (void)load:(void(^)())success failure:(void(^)(NSError *error))failure
{
    AKEntityManager *configuration = [[self class] sharedManager];
    
    [configuration.objectManager getObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end