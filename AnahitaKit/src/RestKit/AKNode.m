//
//  AKNode.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKRestKit.h"


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
    configuration.pathPatternForGettingCollection = @"people/people";
    configuration.pathPatternForGettingEntity = @"people/person/:nodeID";
    [configuration.mappingForResponse addAttributeMappingsFromArray:@[@"name",@"body"]];
}

@end