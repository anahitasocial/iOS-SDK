//
//  AKTableViewControllerEntityActors.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Vendors/RestKit.h"
#import "Vendors/RKTableController.h"

#import "AKEntityListTableViewController.h"

@class RKTableController;

@interface AKActorListTableViewController : UITableViewController <RKTableControllerDelegate, UISearchBarDelegate>
{

@protected
    NSInteger _offset;
    BOOL _locked;
    RKTableController *_tableController;
    BOOL _showSearchBar;
    
}

@property (nonatomic,copy) Class actorClass;
@property (nonatomic,copy) NSString *resourceName;
@property (nonatomic,copy) NSString *resourcePath;
@property (nonatomic,assign) BOOL showSearchBar;

@end
