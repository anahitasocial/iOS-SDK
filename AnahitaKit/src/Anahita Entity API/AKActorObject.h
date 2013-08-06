//
//  AKActorObject.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-13.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKActorObject
 
 @abstract
 Base actor object
 
*/
@interface AKActorObject : AKEntityObject <AKFollowableEntityBehavior, AKPortriableBehavior>

/** @abstract Actor name */
@property (nonatomic,strong) NSString *name;

/** @abstract Actor image URLs */
@property (nonatomic,strong) AKImageURLs *imageURL;

/** @abstract Actor follower count */
@property (nonatomic,strong) NSNumber* followerCount;

/** @abstract If an actor is administrable, it will have a list of administratorIds */
@property (nonatomic,strong) NSArray *administratorIds;

/** @abstract If an actor is the leader of the current logged in user */
@property (nonatomic,assign,getter=leader) BOOL isLeader;

/** @abstract If an actor is the follower of the current logged in user */
@property (nonatomic,assign,getter=follower) BOOL isFollower;

/** @abstract If an actor is the mutual relationship of the current logged in user */
@property (nonatomic,readonly) BOOL isMutual;

@end

/**
 @class AKPersonObject
 
 @abstract
 Person object
 
*/
@interface AKPersonObject : AKActorObject

/** @abstract Person username */
@property(nonatomic,strong) NSString *username;

/** @abstract Person eamil */
@property(nonatomic,strong) NSString *email;

/** @abstract Person password */
@property(nonatomic,strong) NSString *password;

/** @abstract Person leader count */
@property(nonatomic,strong) NSNumber* leaderCount;

/** @abstract Person mutual count */
@property (nonatomic,strong) NSNumber* mutualCount;

/** @abstract leaders */
@property(nonatomic,strong) RKObjectPaginator *paginatorForLeaders;

/**
 @method
 
 @abstract
*/
- (void)follow:(AKActorObject*)actorObject onSuccess:(AKOnSuccessBlock)success onFailure:(AKOnFailureBlock)failure;

/**
 @method
 
 @abstract
*/
- (void)unfollow:(AKActorObject*)actorObject onSuccess:(AKOnSuccessBlock)success onFailure:(AKOnFailureBlock)failure;

@end

typedef AKPersonObject ComPeoplePerson;