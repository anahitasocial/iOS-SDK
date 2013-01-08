//
//  AKEntityBehaviors.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKActorObject;
@class AKPersonObject;
@class RKObjectLoader;
@class RKObjectPaginator;
@protocol RKObjectPaginatorDelegate;

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

/**
 @protocol AKFollowableEntityBehavior
 
 @abstract
 
*/
@protocol AKFollowableEntityBehavior <AKMixin>

@optional

/**
 @method
 
 @abstract
*/
- (BOOL)canFollow;

/**
 @method
 
 @abstract
*/
- (BOOL)canUnfollow;

/** 
 @method 
 
 @abstract
*/
- (void)addFollower:(AKPersonObject*)person onSuccess:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure;

/** 
 @method 
 
 @abstract
*/
- (void)deleteFollower:(AKPersonObject*)person onSuccess:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure;

/** 
 @method 
 
 @abstract
*/
- (RKObjectPaginator*)paginatorForFollowers;

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

/**
 @protocol AKVotableBehavior
 
 @abstract
 Votable behavior 
*/
@protocol AKVotableBehavior <AKMixin>

@required

/** @abstract ownable behavior */
@property(nonatomic,strong) NSNumber *voteUpCount;

@optional

/** 
 @method 
 
 @abstract 
 Return a paginator for voters
*/
@property(nonatomic,readonly) RKObjectLoader* voters;

/** 
 @method 
 
 @abstract 
 Return if the viewer can vote on votable object
*/
- (BOOL)canVote;

/** 
 @method 
 
 @abstract 
 Return if the viewer can unvote on votable object
*/
- (BOOL)canUnVote;

/** 
 @method 
 
 @abstract 
 votedown an object
*/
- (void)voteDown:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure;

/** 
 @method 
 
 @abstract 
 voteup on an object
*/
- (void)voteUp:(AKOnSuccessBlock)onSuccess onFailure:(AKOnFailureBlock)onFailure;

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

#pragma mark -

/**
 @protocol AKPortriableBehavior
 
 @abstract
 Portriable mixin 
*/
@protocol AKPortriableBehavior <AKMixin>

@optional

/** 
 @method 
 
 @abstract 
 
*/
- (void)setPortraitImage:(UIImage*)image;

/** 
 @method 
 
 @abstract 
 
*/
- (void)setPortraitImageData:(NSData*)data;

@end

#pragma mark -

@protocol AKOwnableBehavior <AKMixin>

@required

/** @abstract ownable behavior */
@property(nonatomic,strong) AKActorObject *owner;

@end