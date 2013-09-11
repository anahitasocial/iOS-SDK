//
//  AKNode.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKAnahitaAPI.h"

@implementation AKNode

+ (instancetype)withID:(int)nodeID
{
    id node = [self new];
    [node setNodeID:[NSString stringWithFormat:@"%d", nodeID]];
    return node;
}

+ (void)configureEntity:(AKEntityManager *)configuration
{
    [configuration.mappingForResponse addAttributeMappingsFromDictionary:@{@"id":@"nodeID"}];
    
    //use the collection path to guess the entity path
    if ( configuration.pathPatternForGettingCollection &&
            !configuration.pathPatternForGettingEntity) {
            configuration.pathPatternForGettingEntity = [NSString stringWithFormat:@"%@/:nodeID", configuration.pathPatternForGettingCollection];
    }
}

@end

@interface AKNode(SocPatternWorkAround)
@property(nonatomic,readonly) NSString* nodeid;
@end
@implementation AKNode(SocPatternWorkAround)
- (NSString*)nodeid {
    return self.nodeID;
}
@end

@interface AKActor()

@property(nonatomic,strong) NSDictionary *imageURL;

@end

@implementation AKActor

+ (void)configureEntity:(AKEntityManager *)configuration
{
    [super configureEntity:configuration];
    [configuration.mappingForResponse addAttributeMappingsFromArray:@[@"name",@"body"]];
    [configuration.mappingForRequest addAttributeMappingsFromArray:@[@"name",@"body"]];
    [configuration.mappingForResponse
        addAttributeMappingsFromArray:@[@"isFollower",@"isLeader",@"leaderCount",@"followerCount", @"imageURL"]];
    
//    RKAttributeMapping *imageMapping = [RKAttributeMapping attributeMappingForKey:@"imageURL" usingTransformerBlock:^id(id value, __unsafe_unretained Class destinationType) {
//        
//    }];    
}

- (void)follow:(AKActor*)actor success:(void (^)(id actor))successBlock failure:(void (^)(NSError *error))failureBlock
{
    //if viewer is following
    if ( self == [AKSession sharedSession].viewer ) {
        actor.isLeader = YES;
    }    
    [actor post:@{@"_action":@"follow"} success:^{
        successBlock(actor);
    } failure:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

- (void)unfollow:(AKActor*)actor success:(void (^)(id actor))successBlock failure:(void (^)(NSError *error))failureBlock
{
    //if viewer is unfollowing
    if ( self == [AKSession sharedSession].viewer ) {
        actor.isLeader = NO;
    }
    [actor post:@{@"_action":@"unfollow"} success:^{
        successBlock(actor);
    } failure:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

- (NSURL*)largeImageURL
{
    NSString *path = [self.imageURL valueForKeyPath:@"large.url"];
    return [NSURL URLWithString:path];
}

- (NSURL*)mediumImageURL
{
    NSString *path = [self.imageURL valueForKeyPath:@"medium.url"];
    return [NSURL URLWithString:path];
}

- (NSURL*)smallImageURL
{
    NSString *path = [self.imageURL valueForKeyPath:@"small.url"];
    return [NSURL URLWithString:path];
}

- (NSURL*)squareImageURL
{
    NSString *path = [self.imageURL valueForKeyPath:@"square.url"];
    return [NSURL URLWithString:path];
}

@end

@implementation AKPerson

+ (void)configureEntity:(AKEntityManager *)configuration
{
    [super configureEntity:configuration];
    configuration.pathPatternForGettingCollection = @"people";
    configuration.pathPatternForGettingEntity = @"people/:nodeID";
    [configuration.mappingForResponse addAttributeMappingsFromArray:@[@"email",@"username"]];
    [configuration.mappingForRequest addAttributeMappingsFromArray:@[@"email",@"username",@"password"]];
    [RKResponseDescriptor responseDescriptorWithMapping:configuration.mappingForResponse
     method:RKRequestMethodPOST | RKRequestMethodGET pathPattern:@"people/session" keyPath:nil statusCodes:
        RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
}

@end

