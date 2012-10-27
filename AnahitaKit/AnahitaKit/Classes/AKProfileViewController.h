//
//  AKProfileViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Vendors/RKTableController.h"

@interface AKProfileViewController : UITableViewController <RKTableControllerDelegate>
{

@protected
    RKTableController *_tableController;    
}

@property (nonatomic,strong) id profileObject;


@end
