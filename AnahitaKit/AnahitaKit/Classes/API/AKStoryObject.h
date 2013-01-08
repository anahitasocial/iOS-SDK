//
//  AKStoryObject.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-01.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKPostObject;
@class AKMediumObject;
@class AKActorObject;

@interface AKStoryQueryObject : AKQueryObject

/** @abstract filter stories by an owner*/
@property(nonatomic,strong) AKActorObject* owner;

/** @abstract filter stories by an array of subject ids */
@property(nonatomic,strong) NSArray* subjectIds;

/** @abstract filter stories by an array of names */
@property(nonatomic,strong) NSArray* names;

/** @abstract filter stories by an array of components */
@property(nonatomic,strong) NSArray* components;

/** @abstract exclude the any comment stories. By default it's set to true */
@property(nonatomic,assign) BOOL excludeCommentStories;

@end

/**
 @class AKStoryObject
 
 @abstract
 Story object 
 */
@interface AKStoryObject : AKEntityObject <AKVotableBehavior>

/** @abstract story name */
@property(nonatomic,copy) NSString* name;

/** @abstract story component */
@property(nonatomic,copy) NSString* component;

/** @abstract story object */
@property(nonatomic,strong) id object;

/** @abstract story objects, if more than one */
@property(nonatomic,strong) NSArray* objects;

/** @abstract story subject */
@property(nonatomic,strong) AKActorObject *subject;

/** @abstract story subject */
@property(nonatomic,strong) AKActorObject *target;

/** @abstract story subject */
@property(nonatomic,strong) NSArray *targets;

/** @abstract story voteups */
@property(nonatomic,strong) NSNumber *voteUpCount;

@end
