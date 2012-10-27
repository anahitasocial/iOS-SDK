//
//  AKProfileViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKProfileViewController.h"
#import "Vendors/UIColor+SSToolkitAdditions.h"

@implementation AKProfileViewController

@synthesize profileObject = _profileObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure tableConroller
    _tableController = [RKTableController tableControllerForTableViewController:self];    
    _tableController.delegate = self;
    _tableController.objectManager = [RKObjectManager sharedManager];
    _tableController.variableHeightRows = YES;  
    
    self.tableView.backgroundColor = [UIColor colorWithHex:@"eee"];    
}

@end
