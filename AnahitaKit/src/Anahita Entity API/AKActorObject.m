//
//  AKActorObject.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-13.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

@implementation AKActorObject

+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    [configuration mapAttributes:@"name", nil];
    [configuration.objectMapping mapAttributes:@"followerCount", nil];
    [configuration.objectMapping mapAttributes:@"imageURL",@"administratorIds",@"isLeader",@"isFollower", nil];    
}

- (BOOL)isMutual
{
    return self.isLeader && self.isFollower;
}

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

@implementation AKPersonObject

+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    [configuration.objectMapping mapAttributes:@"leaderCount",@"mutualCount",@"username",@"email", nil];
    [configuration.objectSerializer mapAttributes:@"username",@"email",@"password", nil];
    [configuration.objectSerializer mapKeyPath:@"avatar" toAttribute:@"portrait"];
}

- (void)follow:(AKActorObject *)actorObject onSuccess:(AKOnSuccessBlock)success onFailure:(AKOnFailureBlock)failure
{
    [actorObject addFollower:self onSuccess:success onFailure:failure];
    actorObject.isLeader = YES;
    [actorObject.commands replaceCommand:kAKFollowActorCommand withCommand:kAKUnfollowActorCommand];
}

- (void)unfollow:(AKActorObject *)actorObject onSuccess:(AKOnSuccessBlock)success onFailure:(AKOnFailureBlock)failure
{
    [actorObject deleteFollower:self onSuccess:success onFailure:failure];
    actorObject.isLeader = NO;
    if ( [actorObject.commands containsCommandWithName:kAKUnfollowActorCommand]) {
        [actorObject.commands replaceCommand:kAKUnfollowActorCommand withCommand:kAKFollowActorCommand];
    }
}

- (RKObjectPaginator*)paginatorForLeaders
{
    NSString *resourcePath       = [self.resourcePath stringByAppendingStringQueryParamaters:@"get=graph&type=leaders"];
    RKObjectPaginator *paginator = [self.sharedConfiguration.objectManager paginatorWithResourcePathPattern:resourcePath];
    paginator.objectMapping = self.sharedConfiguration.collectionMapping;
    return paginator;
}

- (BOOL)validateName:(id*)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil || [*ioValue length] == 0 ) {
        *outError = [NSError validationErrorWithKey:@"name" code:kAKMissingValueError message:
                     NSLocalizedString(@"name can't be empty", @"")
                     ];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateUsername:(id*)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil || [*ioValue length] == 0 ) {
        *outError = [NSError validationErrorWithKey:@"username" code:kAKMissingValueError message:
                     NSLocalizedString(@"username can't be empty", @"")
                     ];
        return NO;
    }
    
    if ( !AKNSRegularExpressionMatch(*ioValue, @"^[A-Za-z0-9_]*$", nil) ) {
        *outError = [NSError validationErrorWithKey:@"username" code:kAKValueHasInvalidFormatError message:
                     NSLocalizedString(@"Username has invalid format", @"")
                     ];
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword:(id*)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        *outError = [NSError validationErrorWithKey:@"password" code:kAKMissingValueError message:
                     NSLocalizedString(@"password can't be empty", @"")
                     ];
        return NO;
    }
    return YES;
}

- (BOOL)validateEmail:(id*)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        *outError = [NSError validationErrorWithKey:@"email" code:kAKMissingValueError message:
                     NSLocalizedString(@"email can't be empty", @"")
                     ];
        return NO;
    }
    
    if ( !AKNSRegularExpressionMatch(*ioValue, @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", nil) ) {
        *outError = [NSError validationErrorWithKey:@"email" code:kAKValueHasInvalidFormatError message:
                     NSLocalizedString(@"Email has invalid format", @"")
                     ];
        return NO;
    }
    return YES;
}

@end