//
//  AKListViewController.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

@protocol AKListDataLoader;
@class NIMutableTableViewModel;
@protocol NICellObject;
@class AKListViewController;

#pragma mark -

@protocol AKListViewControllerDelegate <NSObject>

@optional

/**
 @method
 
 @abstract
*/
- (id<NICellObject>)listViewController:(AKListViewController*)listViewController
            cellObjectForObject:(id)object;

/**
 @method
 
 @abstract
*/
- (BOOL)listViewController:(AKListViewController*)listViewController
        didSelectCellObject:(id<NICellObject>)cellObject atIndexPath:(NSIndexPath*)indexPath;

/**
 @method
 
 @abstract
*/
- (void)listViewController:(AKListViewController*)listViewController
        noResultFoundForPage:(NSUInteger)page;

@end

#pragma mark -

@interface AKListViewController : UIViewController <AKListViewControllerDelegate, AKListDataLoaderDelegate, NITableViewModelDelegate,UITableViewDelegate>
{
    @protected
    
    //table view (list view)
    UITableView *_tableView;
    
    //table model contains the cell model for drawing the list
    NIMutableTableViewModel *_tableModel;

    //can register actions to be performs for cell class
    NITableViewActions *_tableActions;
}

/**
 @method
 
 @abstract
*/
+ (instancetype)listViewControllerWithDataLoader:(id<AKListDataLoader>)dataLoader;

/** @abstract **/
@property(nonatomic,strong) id<AKListDataLoader> listDataLoader;

/** @abstract **/
@property(nonatomic,assign) id<AKListViewControllerDelegate> delegate;

/** @abstract **/
@property(nonatomic,strong,readonly) UITableView *tableView;

/** @abstract **/
@property(nonatomic,strong,readonly) NIMutableTableViewModel *tableModel;

/** @abstract **/
@property(nonatomic,strong,readonly) NITableViewActions *tableActions;

@end
