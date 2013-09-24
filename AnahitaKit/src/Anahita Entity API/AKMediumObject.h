//
//  AKMediumObject.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

/**
 @class AKMediumObject
 
 @abstract
 Medium posts
*/
@interface AKMediumObject : AKEntityObject <AKOwnableBehavior>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *body;
@property(nonatomic,strong) AKPersonObject *author;
@property(nonatomic,strong) AKPersonObject *editor;

/** @abstract Only mapped if entity implments AKPortriableBehavior */
@property (nonatomic,strong) AKImageURLs *imageURL;

/** @abstract Only mapped if entity implments AKVotableBehavior */
@property (nonatomic,strong) NSNumber *voteUpCount;

/** @abstract Only mapped if entity implments AKOwnableBehavior */
@property (nonatomic,strong) AKActorObject *owner;

@end

@class AKPersonObject;

/**
 @class AKPostObject
 
 @abstract
 Post object
 */
@interface AKPostObject : AKMediumObject <AKVotableBehavior>

@end

typedef AKPostObject ComPostsPost;

/**
 @class AKPostObject
 
 @abstract
 Post object
 */
@interface AKPhotoObject : AKMediumObject <AKPortriableBehavior, AKVotableBehavior>

@end