//
//  AKActorHeader.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-04.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKActorObject;

/**
 @class AKActorHeaderView
 
 @abstract
 Displays on top of AKActorDetailViewController
 
*/
@interface AKActorHeaderView : UIView
{

@protected
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_metaLabel;
    UIButton *_followersBtn;
}

/**
 @method
 
 @abstract
 
 @return 
*/
- (id)initWithActor:(AKActorObject*)actorObject;

/** @abstract Actor object */
@property(nonatomic,readonly) AKActorObject *actorObject;

/** @abstract Actor object */
@property(nonatomic,weak) id<AKViewNotificationDelegate> notificationDelegate;

@end
