//
//  AKMediumDetailViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-24.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKMediumDetailViewController.h"

@interface AKMediumDetailViewController ()
    <NITableViewModelDelegate,UITableViewDelegate,AKViewNotificationDelegate>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation AKMediumDetailViewController
{
    NIMutableTableViewModel *_tableModel;
    
    UITableView *_tableView;
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    id cellFactory = [NICellFactory class];
    _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:cellFactory];
    
    _tableView.dataSource = _tableModel;
    _tableView.delegate   = self;
    _tableView.backgroundColor = HEXCOLOR(0xf1f1f1);
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    self.view = _tableView;    
}

- (void)viewDidLoad
{
    NSAssert(self.medium, @"Medium object can not be NULL");
    
    [_tableModel addObject:
        [[AKEntityCellObject alloc] initWithEntityObject:self.medium cellClass:[AKMediumObjectDetailViewCell class] cellActions:nil]
    ];
    
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(AKEntityObjectCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.notificationDelegate = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = tableView.rowHeight;
  id<NICellObject> object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
  Class cellClass = [object cellClass];
  if ([cellClass respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
    height = [cellClass heightForObject:object atIndexPath:indexPath tableView:tableView];
  }
  return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark AKViewNotificationDelegate

- (void)view:(UITableViewCell *)cell didPostNotification:(NSNotification *)aNotification
{
    //handle URL
    if ( aNotification.name == kAKViewDidSelectURLNotification ) {
        NIWebController *webController = [[NIWebController alloc] initWithURL:aNotification.object];
        [self.navigationController pushViewController:webController animated:YES];
        return;
    }
    
    else if ( aNotification.name == kAKViewDidSelectLikeActionNotification ) {
        id <AKVotableBehavior> object = aNotification.object;
        [object voteUp:nil onFailure:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    else if ( aNotification.name == kAKViewDidSelectUnLikeActionNotification ) {
        id <AKVotableBehavior> object = aNotification.object;
        [object voteDown:nil onFailure:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    else if ( aNotification.name == kAKViewDidSelectObjectVotersActionNotification ) {
    
        id <AKVotableBehavior> object = aNotification.object;
        //show voters
        AKActorListViewController *actorList = [AKActorListViewController new];
        actorList.shouldShowSearchBar = NO;
        actorList.objectLoader =  object.voters;
        [self.navigationController pushViewController:actorList animated:YES];
    }
    
    else if ( aNotification.name == kAKViewDidSelectViewObjectInDetailNotification ) {
        if ( [aNotification.object isKindOfClass:[AKActorObject class]] ) {
            AKActorDetailViewController *controller = [AKActorDetailViewController detailViewControllerForActor:aNotification.object];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }            
    }
}

@end
