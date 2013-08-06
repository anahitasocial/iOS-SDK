//
//  AKEntityAttributes.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 List of most commandly used commands
 */
extern NSString *const kAKFollowActorCommand;
extern NSString *const kAKUnfollowActorCommand;
extern NSString *const kAKBlockActorCommand;
extern NSString *const kAKUnsubscribeCommand;
extern NSString *const kAKSubscribeCommand;
extern NSString *const kAKVoteupCommand;
extern NSString *const kAKUnvoteCommand;
extern NSString *const kAKEditCommand;

/**
 @class AKCommandList
 
 List of commands that can be performed on an entity
 
 */
@interface AKCommandList : NSObject

/**
 Initialized a list of commands
 */
- (id)initWithArrayOfCommands:(NSArray*)commands;

/**
 Return if the list contains a command
 */
- (BOOL)containsCommandWithName:(NSString*)commandName;

/**
 Adds a command
 */
- (void)addCommand:(NSString*)aCommand;

/**
 Removes command
 */
- (void)removeCommand:(NSString*)aCommand;

/**
 Replaces an old command with a new one. if the old command doesn't 
 exits it just adds the new one
 */
- (void)replaceCommand:(NSString*)oldCommand withCommand:(NSString*)newCommand;

@end

extern NSString *const kAKLargeImageURL;
extern NSString *const kAKSmallImageURL;
extern NSString *const kAKSquareImageURL;
extern NSString *const kAKMediumImageURL;

/**
 @class AKImageURLs
 
 Contains ImageURLs
 */
@interface AKImageURLs : NSObject

/**
 @method
 
 @abstract
 Return a URL for an image size
 
 @param A string representing the image size
 @return The URL pointing the image resource
 */
- (NSURL*)imageURLWithImageSize:(NSString*)imageSize;

/**
 @method
 
 @abstract
 
 @return
*/
- (CGSize)imageSizeForSizeName:(NSString*)sizeName;

@end

