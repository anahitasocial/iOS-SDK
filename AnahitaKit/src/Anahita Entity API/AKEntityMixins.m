//
//  AKEntityBehaviors.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
#import "NSString+NimbusCore.h"

@interface AKVotableBehavior : NSObject @end

@implementation AKVotableBehavior

+ (void)mixedWithClass:(id)mixerClass
{
    AKEntityConfiguration *config = [mixerClass sharedConfiguration];
    if ( [config.objectMapping mappingForAttribute:@"voteUpCount"] == NULL ) {
        [config.objectMapping mapAttributes:@"voteUpCount", nil];
    }
}

- (BOOL)canUnVote
{
    MIXER_VAR(AKEntityObject<AKVotableBehavior>*);
    return [mixer.commands containsCommandWithName:kAKUnvoteCommand];
}

- (BOOL)canVote
{
    MIXER_VAR(AKEntityObject<AKVotableBehavior>*);
    return [mixer.commands containsCommandWithName:kAKVoteupCommand];
}

- (void)voteUp:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    MIXER_VAR(AKEntityObject<AKVotableBehavior>*);
    //lets increment the voteup first
    mixer.voteUpCount = [NSNumber numberWithInt:mixer.voteUpCount.intValue + 1];
    if ( mixer.commands ) {
        [mixer.commands removeCommand:kAKVoteupCommand];
        [mixer.commands addCommand:kAKUnvoteCommand];
    }
    RKObjectLoader *loader = mixer.objectLoader;
    loader.method = RKRequestMethodPOST;
    loader.params = @{@"action":@"vote"};
    loader.onDidLoadResponse = ^(RKResponse *response) {
        if ( response.isOK ) {
            if ( onSuccess)
                onSuccess();
        }
    };
    loader.onDidFailWithError = onFailure;
    [loader send];
}

- (void)voteDown:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    MIXER_VAR(AKEntityObject<AKVotableBehavior>*);
    mixer.voteUpCount = [NSNumber numberWithInt:mixer.voteUpCount.intValue - 1];
    if ( mixer.commands ) {
        [mixer.commands addCommand:kAKVoteupCommand];
        [mixer.commands removeCommand:kAKUnvoteCommand];
    }
    RKObjectLoader *loader = mixer.objectLoader;
    loader.method = RKRequestMethodPOST;
    loader.params = @{@"action":@"unvote"};
    loader.onDidLoadResponse = ^(RKResponse *response) {
        if ( response.isOK ) {
            if ( onSuccess)
                onSuccess();
        }
    };
    loader.onDidFailWithError = onFailure;
    [loader send];
}

- (RKObjectLoader*)voters
{
    MIXER_VAR(AKEntityObject*);
    NSString *resourcePath       = [mixer.resourcePath stringByAppendingStringQueryParamaters:@"get=voters"];
    RKObjectLoader *objectLoader = [mixer.sharedConfiguration.objectManager loaderWithResourcePath:resourcePath];
    objectLoader.objectMapping = [AKActorObject sharedConfiguration].collectionMapping;
    return objectLoader;
}

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

@interface AKFollowableEntityBehavior : NSObject @end

@implementation AKFollowableEntityBehavior


- (void)addFollower:(AKPersonObject*)person onSuccess:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    MIXER_VAR(AKEntityObject*);
    RKObjectLoader *loader = mixer.objectLoader;
    loader.method = RKRequestMethodPOST;
    loader.params = @{@"action":@"addfollower",@"actor":person.identifier};
    loader.onDidLoadObject = ^(id object) {
        if ( onSuccess && object )
            onSuccess();
    };
    loader.onDidFailWithError = onFailure;    
    [loader send];
}

- (void)deleteFollower:(AKPersonObject*)person onSuccess:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure
{
    MIXER_VAR(AKEntityObject*);
    RKObjectLoader *loader = mixer.objectLoader;
    loader.method = RKRequestMethodPOST;
    loader.params = @{@"action":@"deletefollower",@"actor":person.identifier};
    loader.onDidLoadObject = ^(id object) {
        if ( onSuccess && object )
            onSuccess();
    };
    loader.onDidFailWithError = onFailure; 
    [loader send];
}

- (BOOL)canFollow
{
    MIXER_VAR(AKEntityObject*);
    return [mixer.commands containsCommandWithName:kAKFollowActorCommand];
}

- (BOOL)canUnfollow
{
    MIXER_VAR(AKEntityObject*);
    return [mixer.commands containsCommandWithName:kAKUnfollowActorCommand];
}

- (RKObjectPaginator*)paginatorForFollowers
{
    MIXER_VAR(AKEntityObject*);
    NSString *resourcePath       = [mixer.resourcePath stringByAppendingStringQueryParamaters:@"get=graph&type=followers"];
    RKObjectPaginator *paginator = [mixer.sharedConfiguration.objectManager paginatorWithResourcePathPattern:resourcePath];
    
    paginator.objectMapping = mixer.sharedConfiguration.collectionMapping;
    return paginator;
}

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

@interface AKPortriableBehavior : NSObject @end

@implementation AKPortriableBehavior

+ (void)mixedWithClass:(id)mixerClass
{
    AKEntityConfiguration *config = [mixerClass sharedConfiguration];
    if ( [config.objectMapping mappingForAttribute:@"imageURL"] == NULL ) {
        [config.objectMapping mapAttributes:@"imageURL", nil];
    }
}

- (void)setPortraitImage:(UIImage*)image
{
    NSData *data =  UIImagePNGRepresentation(image);
    [self setValue:[AKParamData paramWithData:data MIMEType:@"image/png"] forKey:@"portrait"];
}

- (void)setPortraitImageData:(NSData*)data
{
    [self setValue:[AKParamData paramWithData:data MIMEType:@"image/png"] forKey:@"portrait"];
}

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

@interface AKOwnableBehavior : NSObject @end

@implementation AKOwnableBehavior

+ (void)mixedWithClass:(id)mixerClass
{
    AKEntityConfiguration *config = [mixerClass sharedConfiguration];
    if ( [config.objectMapping mappingForRelationship:@"owner"] == NULL ) {
        [config.objectMapping mapRelationship:@"owner" withMapping:AKActorObject.sharedConfiguration.objectMapping];
    }
}

@end