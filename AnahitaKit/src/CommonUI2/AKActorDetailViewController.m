//
//  AKActorDetailViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
#import "AKStoryListViewController.h"
#import "AKPullToRefreshView.h"

@interface AKUIActionCellObject : NITitleCellObject

- (id)initWithCellClass:(Class)cellClass;

@end

@implementation AKUIActionCellObject

- (id)initWithCellClass:(Class)cellClass
{
    return [super initWithCellClass:[NITitleCellObject class]];
}

@end

@interface AKUIActionCell :  NITextCell

@end

@implementation AKUIActionCell

@end

@interface AKActorDetailViewController(PrivateMethods)
        <RKObjectLoaderDelegate, UITableViewDelegate, PullToRefreshViewDelegate>

@end

@implementation AKActorDetailViewController
{
    UITableView *_tableView;
//    
//    NIMutableTableViewModel *_tableModel;
//    NITableViewActions *_tableActions;
}

+ (AKActorDetailViewController*)detailViewControllerForActor:(AKActorObject*)anActor
{
    Class actorClass = [anActor class];
    NSString *className = [NSStringFromClass(actorClass) stringByAppendingString:@"DetailViewController"];
    Class detailViewController = AKNSClassFromListOfStrings(className, @"AKActorDetailViewController", nil);
    AKActorDetailViewController* controller = [detailViewController new];
    controller.entityObject = anActor;
    return controller;
}

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(self.entityObject != nil , @"%@ : Actor object have not been set yet.",[self class]);
    
    _tableView = self.mainContentView;
    
    _tableView.pullToRefreshView.delegate = self;
    
    //resize table view
    _tableView.frame = CGRectWithScreenWidth(0,0,
        AKMainScreenSize.height -
        (!self.navigationController ? NIToolbarHeightForOrientation(self.interfaceOrientation) : 0) -
        (self.tabBarController ? NIToolbarHeightForOrientation(self.interfaceOrientation) : 0 ) - 
        NIStatusBarHeight()            
            );
    
    [self.view addSubview:_tableView];
    
    [_tableView.pullToRefreshView setState:PullToRefreshViewStateLoading];
    
    [self.entityObject loadWithDelegate:self];
    
    self.title = NSLocalizedString(@"Profile", nil);
    
}

- (void)viewDidUnload
{
    
}

- (UITableView*)mainContentView
{
    //story view controller
    AKStoryListViewController *storyListViewController = [AKStoryListViewController new];
    
    storyListViewController.storyQuery = [AKStoryQueryObject queryUsingBlock:^(AKStoryQueryObject *query) {
        query.owner = self.entityObject;
        query.names = @[@"post_add",@"flyer_add"];
        //query.subjectIds = @[self.entityObject.identifier];
    }];
    
    [self addChildViewController:storyListViewController];
    
    return storyListViewController.tableView;
}

#pragma mark -
#pragma mark RKObjectDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{        
    //add actor header
    Class header = AKNSClassFromListOfStrings(
        [NSStringFromClass([object class]) stringByAppendingString:@"HeaderView"],
        @"AKActorHeaderView", nil);
    
    AKActorHeaderView *actorHeader = [[header alloc] initWithActor:object];

    actorHeader.notificationDelegate = self;
    
    UITableView *tableView = _tableView;
    
    tableView.tableHeaderView = actorHeader;
    
    NSString *buttonTitle;
    
    if ( [self.entityObject canFollow] ) {
        buttonTitle = @"Follow";
    }
    else if ([self.entityObject canUnfollow]) {
        buttonTitle = @"Unfollow";
    }
    
    if ( buttonTitle )
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(buttonTitle, nil) style:UIBarButtonItemStyleBordered target:self action:@selector(followActorAction)];
    
}

#pragma mark - 
#pragma mark PullToRefreshViewDelegate

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    AKEntityListViewController *controller = [self.childViewControllers objectAtIndex:0];
    [controller reloadData];
    _tableView.pullToRefreshView.delegate  = self;
    [self.entityObject loadWithDelegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark Actor Actions

- (void)followActorAction
{
    NSAssert(AKSessionObject.viewer, @"There's no authenticated viewer for the session");
    
    UIBarButtonItem *item  = self.navigationItem.rightBarButtonItem;
    
    if ( [self.entityObject canFollow] ) {
        [AKSessionObject.viewer follow:self.entityObject onSuccess:nil onFailure:nil];
        item.title = NSLocalizedString(@"Unfollow", nil);
    }
    
    else if ( [self.entityObject canUnfollow] ) {
        [AKSessionObject.viewer unfollow:self.entityObject onSuccess:nil onFailure:nil];
        item.title = NSLocalizedString(@"Follow", nil);
    }
}

- (void)editActorAction
{
    NSAssert(AKSessionObject.viewer, @"There's no authenticated viewer for the session");
    AKPersonFormViewController *contoller = [AKPersonFormViewController new];
    contoller.personObject = self.entityObject;
    [self presentViewController:contoller animated:YES completion:nil];
}

- (void)displayActorFollowersAction
{
    AKGraphViewController *controller = [AKGraphViewController new];
    controller.actor = self.entityObject;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 
#pragma mark AKViewNotificationDelegate

- (void)view:(UIView *)view didPostNotification:(NSNotification *)aNotification
{
    if ( [aNotification.name isEqualToString:kAKViewDidSelectFollowersActionNotification]) {
        [self displayActorFollowersAction];
    }
    
    else if ([aNotification.name isEqualToString:kAKViewDidSelectFollowActionNotification]) {
        [self followActorAction];
    }
    
    else if ([aNotification.name isEqualToString:kAKViewDidSelectUnFollowActionNotification]) {
        [self unfollowActorAction];
    }    
}

@end
