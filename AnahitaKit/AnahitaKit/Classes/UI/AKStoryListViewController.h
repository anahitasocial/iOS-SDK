//
//  AKStoryListViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


/**
 @class AKStoryListViewController
 
 @abstract
 Displays a list of stories.
*/
@interface AKStoryListViewController : AKEntityListViewController

/** @abstract Set a query to show a list of stories */
@property(nonatomic,strong) AKStoryQueryObject *storyQuery;

@end
