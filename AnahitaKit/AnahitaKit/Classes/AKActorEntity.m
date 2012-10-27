//
//  AKEntityActor.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Vendors/RestKit.h"
#import "AKActorEntity.h"
#import "AKProfileViewController.h"
#import "AKActorProfileViewController.h"

@implementation AKActorEntity

+ (RKObjectMapping *)objectMapping;
{
    RKObjectMapping *mapping = [super objectMapping];
    
    if ( [self conformsToProtocol:@protocol(AKEntityDescribable)] ) {
        [mapping mapAttributes:@"name",@"body", nil];    
    }
    
    if ( [self conformsToProtocol:@protocol(AKEntityPortriable)] ) {
        [mapping mapAttributes:@"imageURLs", nil];    
    }
    
    [mapping mapAttributes:@"location",@"address", nil];
    
    if ( [self conformsToProtocol:@protocol(AKActorEntityFollowable)] ) {
        [mapping mapAttributes:@"followerCount", nil];
    }
    
    if ( [self conformsToProtocol:@protocol(AKActorEntityLeadeable)] ) {
        [mapping mapAttributes:@"leaderCount",@"mutualCount", nil];
    }    
    
    return mapping;
}

@synthesize name    = _name;
@synthesize body    = _body;
@synthesize address = _address;
@synthesize imageURLs = _imageURLs;
@synthesize location = _location;
@synthesize followerCount = _followerCount;
@synthesize leaderCount = _leaderCount;
@synthesize mutualCount = _mutualCount;

- (AKProfileViewController*)profileViewController
{
    AKActorProfileViewController *profile = [[AKActorProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    profile.actor = self;
    return profile;
    /*
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                userInfo:nil];
    */
}

@end
