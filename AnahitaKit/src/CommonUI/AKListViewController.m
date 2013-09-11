//
//  AKListViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKCommonUI.h"

@interface AKListViewController () <UITableViewDelegate>

@property(nonatomic,strong,readwrite) NIMutableTableViewModel *tableModel;
@property(nonatomic,strong,readwrite) UITableView* tableView;

@end

@implementation AKListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)listViewControllerWithDataLoader:(id<AKListDataLoader>)dataLoader
{
    AKListViewController *controller = [[self alloc] init];
    controller.listDataLoader = dataLoader;
    return controller;
}

- (id)init
{
    if ( self = [super init] ) {
        self.delegate = self;
    }    
    return self;
}

- (UITableView*)tableView {
    if ( !_tableView ) {
        [self view];
    }
    return _tableView;
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

    self.tableView.delegate   = self;
    
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(self.listDataLoader, @"No dataloader specified");
    
    __weak id this = self;    
    
    self.listDataLoader.delegate = self;
    
    [self.listDataLoader loadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NICellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.tableModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<NICellObject> cellObject = [self.tableModel objectAtIndexPath:indexPath];
    BOOL deselect = NO;
    if ( [self.delegate respondsToSelector:@selector(listViewController:didSelectCellObject:atIndexPath:)]) {
        deselect = [self.delegate listViewController:self didSelectCellObject:cellObject atIndexPath:indexPath];
    }
    if ( deselect ) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - 
#pragma mark AKListViewControllerDelegate

- (void)listViewController:(AKListViewController*)listViewController
        didSelectCellObject:(id<NICellObject>)cellObject

{
    //subclass must decicde what to do
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(y > h + reload_distance && self.listDataLoader.canLoadMoreData) {
       [self.listDataLoader loadMoreData];
    }
}

- (NIMutableTableViewModel*)tableModel
{
    if ( !_tableModel ) {
        _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:self];
    }
    return _tableModel;
}

#pragma mark - 
#pragma mark NITableViewModelDelegate

- (UITableViewCell*)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    UITableViewCell *cell = [NICellFactory tableViewModel:tableViewModel
                cellForTableView:tableView atIndexPath:indexPath withObject:object];
    return cell;
}

#pragma mark - 
#pragma mark AKListDataLoaderDelegate

- (void)listLoader:(AKListDataLoader *)listLoader willLoadObjectsForPage:(NSUInteger)page
{

}

- (void)listLoader:(AKListDataLoader *)listLoader didLoadObjects:(NSArray *)objects forPage:(NSUInteger)page
{
   if ( page == 0 ) {
        self.tableModel = nil;
        self.tableView.dataSource = self.tableModel;
   }
   
   if ( objects.count > 0 )
   {
        id<AKListViewControllerDelegate> delegate = self.delegate;
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<NICellObject> cellObject = [delegate listViewController:self cellObjectForObject:obj];
            [self.tableModel addObject:cellObject];
        }];
        [self.tableView reloadData];
   } else {
        if ([self.delegate respondsToSelector:@selector(listViewController:noResultFoundForPage:)]) {
            [self.delegate listViewController:self noResultFoundForPage:page];
        }
   }
}

- (void)listLoader:(AKListDataLoader *)didFail :(NSError *)error
{

}

@end
