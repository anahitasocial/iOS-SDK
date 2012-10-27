//
//  AKTableViewControllerEntityList.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Vendors/RestKit.h"

@interface AKEntityListTableViewController : UITableViewController 
{
    
@protected
    NSArray *_objects;
    RKObjectManager *_objectManager;
}

@property(nonatomic,readonly) NSArray *objects;

@end
