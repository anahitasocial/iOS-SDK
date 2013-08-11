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

@implementation AKPerson

+ (void)configureEntity:(AKEntityManager *)configuration
{
    [super configureEntity:configuration];
    configuration.pathPatternForGettingCollection = @"people";
    configuration.pathPatternForGettingEntity = @"people/:nodeID";
    [configuration.mappingForResponse addAttributeMappingsFromArray:@[@"name",@"body",@"email",@"username"]];
    [configuration.mappingForRequest addAttributeMappingsFromArray:@[@"password"]];
    [RKResponseDescriptor responseDescriptorWithMapping:configuration.mappingForResponse
     method:RKRequestMethodPOST | RKRequestMethodGET pathPattern:@"people/session" keyPath:nil statusCodes:
        RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
}

@end

