//
//  AKGraphViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-23.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKGraphViewController.h"

@interface AKGraphViewController ()

@end

@implementation AKGraphViewController

- (void)viewDidLoad
{
    //lets add a segment control
    if ( self.segmentControl.selectedSegmentIndex == kAKGraphFollowersSegmentedControlIndex )
        self.objectPaginator = self.actor.paginatorForFollowers;
    else if ( [self.actor respondsToSelector:@selector(paginatorForLeaders)])
        self.objectPaginator = [((id)self.actor) paginatorForLeaders];
    
    [super viewDidLoad];
}

- (UISegmentedControl*)segmentControl
{
    if ( !_segmentControl ) {
        NSMutableArray *segments = [NSMutableArray arrayWithObject:@"Followers"];
        if ( [self.actor respondsToSelector:@selector(paginatorForLeaders)] ) {
            [segments addObject:@"Leaders"];
        }
        _segmentControl = [[UISegmentedControl alloc] initWithItems:segments];
        _segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [_segmentControl setSelectedSegmentIndex:kAKGraphFollowersSegmentedControlIndex];
        [_segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        //only add it to title if there's at least 2 segments
        if ( segments.count > 1 ) {
            self.navigationItem.titleView = _segmentControl;
        }
    }
    
    return _segmentControl;
}

- (void)segmentedControlValueDidChange:(id)sender
{
    //lets add a segment control
    if ( self.segmentControl.selectedSegmentIndex == kAKGraphFollowersSegmentedControlIndex )
        self.objectPaginator = self.actor.paginatorForFollowers;
    else if ( [self.actor respondsToSelector:@selector(paginatorForLeaders)])
        self.objectPaginator = [((id)self.actor) paginatorForLeaders];
   
   [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
