//
//  AKEntityListViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
#import "AKPullToRefreshView.h"

@interface AKEntityListViewController() <UITableViewDelegate,
        NIMutableTableViewModelDelegate,
        AKEntityListViewControllerDelegate,
        PullToRefreshViewDelegate>


@end

@implementation AKEntityListViewController
{
    UITableViewStyle _tableViewStyle;
    
    BOOL _paginatorMorePagesAvailable;
    
    NSMutableArray *_entities;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStylePlain;
    if ( self = [super initWithStyle:style] ) {
        self.delegate = self;
        self.shouldShowSearchBar = YES;
        _entities = [NSMutableArray array];
    }    
    return self;
}

- (id)init
{
    if ( self = [super init] ) {
        _tableViewStyle = UITableViewStylePlain;
        self.shouldShowEmptyListMessage = YES;
        self.delegate = self;        
    }    
    return self;
}

/**
 Load view replaced the original view with a table view. Set the data source to the
 model
 
 */
- (void)loadView
{
    [super loadView];
    
    self.tableView.dataSource = self.tableModel;
    self.tableView.backgroundColor = HEXCOLOR(0xf1f1f1);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;    
}

- (void)viewDidLoad
{
    if ( self.objectPaginator ) {
        [self.objectPaginator loadNextPage];
    }
    
    if ( self.objectLoader ) {
        [self.objectLoader send];
    }
    
    //????: Can we have an entity list controller without object loader or object paginator
    [self.tableView.pullToRefreshView setState:PullToRefreshViewStateLoading];
    self.tableView.pullToRefreshView.delegate = self;
    
    [super viewDidLoad];
}

#pragma mark - Set Object Loader

- (void)setObjectPaginator:(RKObjectPaginator *)objectPaginator
{
    _objectPaginator = objectPaginator;
    _objectPaginator.delegate = self;
    _paginatorMorePagesAvailable = YES;
}

- (void)setObjectLoader:(RKObjectLoader *)objectLoader
{
    _objectLoader = objectLoader;
    _objectLoader.delegate = self;
}

#pragma mark -
#pragma mark Load Table Model

- (NITableViewModel*)tableModel
{
    if ( _tableModel == nil ) {
       _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        
    }
    return (NITableViewModel*)_tableModel;
}

#pragma mark - 
#pragma mark Reload Data

- (void)reloadData
{
    if ( self.shouldShowSearchBar ) {
        self.tableView.tableHeaderView = NULL;
    }
    
    if ( self.objectLoader ) {
        _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        self.tableView.dataSource = _tableModel;
        [self.objectLoader send];
    }
    
    else if ( self.objectPaginator ) {
        _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
        self.tableView.dataSource = _tableModel;
        _paginatorMorePagesAvailable = YES;
        [self.objectPaginator loadPage:0];
    }
    
    [self.tableView.pullToRefreshView setState:PullToRefreshViewStateLoading];        
    self.tableView.pullToRefreshView.delegate = self;
    [_entities removeAllObjects];
}

#pragma mark - 
#pragma mark PullToRefreshViewDelegate

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    [self reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = tableView.rowHeight;
  id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];  
  if ([self.entityCellClass respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
    height = [self.entityCellClass heightForObject:object atIndexPath:indexPath tableView:tableView];
  }
  return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKEntityCellObject *cellObject = [self.tableModel objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ( [cell respondsToSelector:@selector(didSelectCellWithObject:)] ) {
        [cell performSelector:@selector(didSelectCellWithObject:) withObject:cellObject];
    }    
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{    
    [self didLoadEntities:objects];
}

- (void)didLoadEntities:(NSArray*)entities
{
    NSMutableArray *cellObjects = [NSMutableArray array];
    
    [_entities addObjectsFromArray:entities];
    
    _paginatorMorePagesAvailable = entities.count > 0;
    
    [self.tableView hidePullToRefreshView];
    
    for(id entity in entities) {
    
        NSArray *actions = [self.delegate entityListViewController:self cellActionsForEntityObject:entity];
        Class cellClass  = [self.delegate entityListViewController:self cellClassForEntityObject:entity];
        
        AKEntityCellObject *cellObject = [[AKEntityCellObject alloc]
                                initWithEntityObject:entity cellClass:cellClass cellActions:actions];
        
        [cellObjects addObject:cellObject];
    }
    
    [_tableModel addObjectsFromArray:cellObjects];

    [self.tableView reloadData];
    
    if ( self.shouldShowSearchBar ) {
    
        self.tableView.tableHeaderView = _entities.count > 0 ? self.searchBarView : NULL;
        //hide the search
        //self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBarView.frame));
    }
    
    if ( _entities.count == 0 && self.shouldShowEmptyListMessage ) {
       UIView *emptyListView = self.emptyListView;
       emptyListView.frame  = CGRectSetWidth(emptyListView.frame, CGRectGetWidth(self.tableView.frame));
       emptyListView.center = self.tableView.center;
       [self.tableView addSubview:emptyListView];
    } else {
        [self.emptyListView removeFromSuperview];
    }
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
}

#pragma mark -
#pragma mark RKObjectPaginator

- (void)paginator:(id)paginator didLoadObjects:(NSArray *)objects forPage:(NSUInteger)page
{
    [self didLoadEntities:objects];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    //paginate
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;

    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        if ( self.objectPaginator && !self.objectPaginator.isLoading && _paginatorMorePagesAvailable ) {
            [self.objectPaginator loadNextPage];
        }
    }
}

- (Class)entityCellClass
{
    if ( nil == _entityCellClass ) {
        _entityCellClass = [AKEntityObjectCell class];
    }
    return _entityCellClass;
}

#pragma mark -
#pragma mark NIMutableTableViewModelDelegate

- (UITableViewCell*)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(AKEntityCellObject*)cellObject
{
  UITableViewCell* cell = nil;
  AKEntityObject *entityObject = cellObject.entityObject;
  Class cellClass = [self.delegate entityListViewController:self cellClassForEntityObject:entityObject];
  NSString* identifier = NSStringFromClass(cellClass);

  cell = [tableView dequeueReusableCellWithIdentifier:identifier];

  if (nil == cell) {
    UITableViewCellStyle style = UITableViewCellStyleDefault;    
    cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
  }

  if ( [cell respondsToSelector:@selector(setNotificationDelegate:)]) {
    [cell performSelector:@selector(setNotificationDelegate:) withObject:self];
  }

  // Allow the cell to configure itself with the object's information.
  if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
    [(id<NICell>)cell shouldUpdateCellWithObject:cellObject];
  }
  return cell;
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
        else if ( [aNotification.object isKindOfClass:[AKMediumObject class]] ) {
            //show the detail
            AKMediumDetailViewController *controller = [AKMediumDetailViewController new];
            controller.medium = aNotification.object;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark -
#pragma mark AKEntityListViewControllerDelegate

- (Class)entityListViewController:(AKEntityListViewController *)controller cellClassForEntityObject:(AKEntityObject *)entityObject
{
    return self.entityCellClass;
}

- (NSArray*)entityListViewController:(AKEntityListViewController *)controller cellActionsForEntityObject:(AKEntityObject *)entityObject
{
    return nil;
}

#pragma mark -
#pragma mark Search bar

- (UIView*)searchBarView
{
    if ( !_searchBarView ) {
        _searchBarView = [[UISearchBar alloc] initWithFrame:CGRectSetHeight(CGRectZero, 40)];
        
        UISearchBar *searchbar = ((UISearchBar*)_searchBarView);
        [searchbar setDelegate:self];
        searchbar.placeholder = NSLocalizedString(@"Enter a keyword", nil);
        searchbar.showsCancelButton = YES;
    }
    return _searchBarView;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ( searchBar.text.length == 0 ) {
        [self searchBarSearchButtonClicked:searchBar];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchValue  = searchBar.text;
    NSString *resourcePath;
    if ( self.objectLoader.resourcePath ) {
        resourcePath = self.objectLoader.resourcePath;
    }
    else {
        resourcePath = self.objectPaginator.patternURL.resourcePath;
    }
    resourcePath = AKNSRegularExpressionReplace(resourcePath, @"q=.*", @"", nil);
    resourcePath = [resourcePath stringByAppendingDictionaryQueryParamaters:@{@"q":searchValue}];
    
    if ( self.objectLoader )
        self.objectLoader.resourcePath  = resourcePath;
    else {
        self.objectPaginator.patternURL = [RKURL URLWithBaseURL:self.objectPaginator.patternURL.baseURL resourcePath:resourcePath];
    }
    [self reloadData];
    
}

#pragma mark - 
#pragma mark - Empty List View

- (NSString*)emptyListMessage
{
    if ( !_emptyListMessage ) {
        _emptyListMessage = NSLocalizedString(@"There are no records", nil);
    }
    return _emptyListMessage;
}

- (UIView*)emptyListView
{
    if ( !_emptyListView ) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.emptyListMessage;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = HEXCOLOR(0xa1a1a1);
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = UITextAlignmentCenter;
        _emptyListView = label;
        _emptyListView.frame = CGRectSetHeight(_emptyListView.frame, 30);
    }
    return _emptyListView;
}

@end
