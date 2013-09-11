//
//  AKNode.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKEntity.h"
#import <Foundation/Foundation.h>

@interface AKNode : AKEntity

/**
 @method
 
 @abstract
*/
+ (instancetype)withID:(int)nodeID;

@property (nonatomic, copy) NSString *nodeID;

@end

@interface AKActor : AKNode


/** @abstract */
@property (nonatomic, copy) NSString *name;

/** @abstract */
@property (nonatomic, copy) NSString *body;

/**
 @method
 
 @abstract
*/
- (void)follow:(AKActor*)actor success:(void (^)(id actor))successBlock failure:(void (^)(NSError* error))failureBlock;

/**
 @method
 
 @abstract
*/
- (void)unfollow:(AKActor*)actor success:(void (^)(id actor))successBlock failure:(void (^)(NSError* error))failureBlock;

/** @abstract */
@property (nonatomic, assign) BOOL isFollower;

/** @abstract */
@property (nonatomic, assign) BOOL isLeader;

/** @abstract */
@property (nonatomic, assign) NSUInteger followerCount;

/** @abstract */
@property (nonatomic, assign) NSUInteger leaderCount;

/** @abstract */
@property(nonatomic,readonly) NSURL *largeImageURL;

/** @abstract */
@property(nonatomic,readonly) NSURL *mediumImageURL;

/** @abstract */
@property(nonatomic,readonly) NSURL *smallImageURL;

/** @abstract */
@property(nonatomic,readonly) NSURL *squareImageURL;

@end

@interface AKPerson : AKActor

/** @abstract */
@property (nonatomic, copy) NSString *email;

/** @abstract */
@property (nonatomic, copy) NSString *username;

/** @abstract */
@property (nonatomic, copy) NSString *password;

@end



