//
//  AKStoryListViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKStoryListViewController.h"

@interface AKStoryListViewController ()

@end

@implementation AKStoryListViewController


- (void)viewDidLoad
{
    self.shouldShowSearchBar = NO;
    self.objectPaginator = [AKStoryObject paginatorWithQuery:self.storyQuery];
    self.entityCellClass = [AKStoryObjectCell class];
    [super viewDidLoad];	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AKStoryQueryObject*)storyQuery
{
    if ( !_storyQuery ) {
        _storyQuery = [AKStoryQueryObject new];
    }
    return _storyQuery;
}

- (void)view:(UIView *)view didPostNotification:(NSNotification *)aNotification

{
    if ( [aNotification.object isKindOfClass:[AKStoryObject class]] ) {
        AKStoryObject *story = (AKStoryObject*)aNotification.object;
        aNotification = [NSNotification notificationWithName:aNotification.name object:story.object];
    }
    [super view:view didPostNotification:aNotification];    
}

@end
