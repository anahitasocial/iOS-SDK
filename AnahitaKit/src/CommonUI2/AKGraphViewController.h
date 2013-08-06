//
//  AKGraphViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-23.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKActorListViewController.h"

enum kAKGraphSegmentedControlIndex {
  kAKGraphFollowersSegmentedControlIndex = 0,
  kAKGraphLeadersSegmentedControlIndex = 1
};

@interface AKGraphViewController : AKActorListViewController
{
    UISegmentedControl *_segmentControl;
}

/** @abstract actor whose graph we want to show */
@property(nonatomic,strong) AKActorObject *actor;

/** @abstract actor whose graph we want to show */
@property(nonatomic,readonly) UISegmentedControl* segmentControl;

@end
