//
//  AKEntityAttributes.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import "AKEntityAttributes.h"
#import <CoreLocation/CoreLocation.h>

#pragma mark -
#pragma mark AKCommandList constants

NSString *const kAKFollowActorCommand = @"follow";
NSString *const kAKUnfollowActorCommand = @"unfollow";
NSString *const kAKBlockActorCommand  = @"block";
NSString *const kAKUnBlockActorCommand  = @"unblock";
NSString *const kAKSubscribeCommand = @"subscribe";
NSString *const kAKUnsubscribeCommand = @"unsubscribe";
NSString *const kAKVoteupCommand = @"vote";
NSString *const kAKUnvoteCommand = @"unvote";
NSString *const kAKEditCommand = @"edit";

#pragma mark -
#pragma mark AKCommandList

///-----------------------------------------------------------------------------
/// @class AKCommandList
///-----------------------------------------------------------------------------

@interface AKCommandList(PrivatMethods)

- (id)initWithMappableValue:(id)mappableValue;

@end

@implementation AKCommandList
{
    NSMutableArray *_commands;
}

- (id)initWithMappableValue:(id)mappableValue
{
    return [self initWithArrayOfCommands:mappableValue];
}

- (id)initWithArrayOfCommands:(NSArray*)commands
{
    if ( self = [super init] ) {
        _commands = [NSMutableArray arrayWithArray:commands];
    }
    
    return self;
}

- (BOOL)containsCommandWithName:(NSString*)commandName
{
    for(NSString *cmd in _commands) {
        if ( [cmd isEqualToString:commandName] ) {
            return YES;
        }
    }
    return NO;
}

- (void)addCommand:(NSString *)aCommand
{
    if ( [self containsCommandWithName:aCommand] == NO ) {
        [_commands addObject:aCommand];
    }
}

- (void)removeCommand:(NSString *)aCommand
{
    [_commands removeObject:aCommand];
}

- (void)replaceCommand:(NSString*)oldCommand withCommand:(NSString*)newCommand
{
    [self removeCommand:oldCommand];
    [self addCommand:newCommand];
}

- (NSString*)description
{
    return [_commands description];
}

@end

#pragma mark -
#pragma mark ImageURL constants

NSString *const kAKLargeImageURL  = @"large";
NSString *const kAKSmallImageURL  = @"small";
NSString *const kAKSquareImageURL = @"square";
NSString *const kAKMediumImageURL = @"medium";

#pragma mark -
#pragma mark AKCommandList

///-----------------------------------------------------------------------------
/// @class AKCommandList
///-----------------------------------------------------------------------------

@interface AKImageURLs(PrivatMethods)

- (id)initWithMappableValue:(id)mappableValue;

@end

@implementation AKImageURLs
{
    NSDictionary *_images;
}

- (id)initWithMappableValue:(id)mappableValue;
{
    if ( self = [super init] )
    {
        if ( [mappableValue isKindOfClass:[NSDictionary class]] )
            _images = mappableValue;
        else
            _images = [NSDictionary dictionary];
    }
    
    return self;
}

- (CGSize)imageSizeForSizeName:(NSString*)sizeName
{
    NSDictionary *image = [_images valueForKey:sizeName];

    if ( image == NULL
        || [image isKindOfClass:[NSNull class]]
        ) {        
        return CGSizeZero;
    }
    
    NSDictionary *imageSize = [image valueForKey:@"size"];
    
    return CGSizeMake([[imageSize valueForKey:@"width"] floatValue], [[imageSize valueForKey:@"height"] floatValue]);
}

- (NSURL*)imageURLWithImageSize:(NSString*)imageSize;
{    
    NSDictionary *image = [_images valueForKey:imageSize];
    
    if ( image == NULL
        || [image isKindOfClass:[NSNull class]]
        ) {        
        return NULL;
    }
    
    NSString *path = [image valueForKey:@"url"];
    
    return [NSURL URLWithString:path];
}

@end

#pragma mark -
#pragma mark CLLocation

///-----------------------------------------------------------------------------
/// @class CLLocation
///-----------------------------------------------------------------------------

@interface CLLocation (PrivateMethods)

- (id)initWithMappableValue:(id)mappableValue;

@end

@implementation CLLocation (PrivateMethods)

- (id)initWithMappableValue:(id)mappableValue
{
    return [self initWithLatitude:[[mappableValue valueForKey:@"latitude"] doubleValue] longitude:[[mappableValue valueForKey:@"longitude"] doubleValue]];
}

@end