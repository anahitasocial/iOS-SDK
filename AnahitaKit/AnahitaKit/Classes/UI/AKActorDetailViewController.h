//
//  AKActorDetailViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKActorHeaderView;

/**
 @class AKActorDetailViewController
 
 @abstract
 Displays the profile view for an actor
 */
@interface AKActorDetailViewController : UIViewController <AKEntityDetailViewController, AKViewNotificationDelegate>

/**
 @method
 
 @abstract
 Instantiate a detail view controller
*/
+ (AKActorDetailViewController*)detailViewControllerForActor:(AKActorObject*)anActor;

/**
 Set the actor entity
 */
@property(nonatomic,strong) AKActorObject *entityObject;

/** @abstract Content View */
@property(nonatomic,readonly) UITableView *mainContentView;

/**
 Alias for setting/getting the entity
 */
//@property(nonatomic,strong,setter=entity:,getter=entity) AKActor* actor;

/**
 @method 
 
 @abstract 
 The viewer follows the actor
 */
- (void)followActorAction;

/**
 @method
 
 @abstract
 The viewer unfollows the actor
 */
- (void)unfollowActorAction;

/**
 @method
 
 @abstract
 The viewer edits the actor
 */
- (void)editActorAction;

/**
 @method
 
 @abstract
 Display the actor followers
 */
- (void)displayActorFollowersAction;

@end
