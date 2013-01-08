//
//  AKEntityListViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@protocol RKObjectPaginatorDelegate;
@class RKObjectPaginator;
@class RKObjectLoader;

/**
 @protocol AKEntityDetailViewController
 
 @abstract
 The interace for the controller class that shows a selected entity in the list
 */
@protocol AKEntityDetailViewController <NSObject>

/**
 @method
 
 @abstract
 Sets the the detail view controller entity object 
 */
- (void)setEntityObject:(AKEntityObject*)entityObject;

@end

@class AKEntityListViewController;

/**
 @protocol AKEntityListViewControllerDelegate
 
 @abstract
*/
@protocol AKEntityListViewControllerDelegate <NSObject>

/** @abstract */
- (Class)entityListViewController:(AKEntityListViewController*)controller
        cellClassForEntityObject:(AKEntityObject*)entityObject;

/** @abstract */
- (NSArray*)entityListViewController:(AKEntityListViewController*)controller
        cellActionsForEntityObject:(AKEntityObject*)entityObject;

@end

/**
 @class AKEntityListViewController
 
 @abstract
 Display a list of entities
 */
@interface AKEntityListViewController : UITableViewController
        <RKObjectLoaderDelegate, NITableViewModelDelegate,
        RKObjectPaginatorDelegate, AKViewNotificationDelegate,UISearchBarDelegate>
{
    
@private
    NIMutableTableViewModel *_tableModel;
}

/**
 @method
 
 @abstract
*/
- (void)reloadData;

/** @abstract an array of entities loaded */
@property(nonatomic,readonly) NSArray *entities;

/** @abstract Loader */
@property(nonatomic,strong) RKObjectPaginator *objectPaginator;

/** @abstract Object Loader */
@property(nonatomic,strong) RKObjectLoader *objectLoader;

/**
 @method
 
 @abstract
 called after each time entities are loaded
*/
- (void)didLoadEntities:(NSArray*)entities;

///-----------------------------------------------------------------------------
/// @name Table Model
///-----------------------------------------------------------------------------

@property (nonatomic,readonly) NITableViewModel *tableModel;

/** 
 @property
 
 @abstract
 The cell object class to use to display the entity within the list. By default
 it uses AKEntityListCellObject
 */
@property(nonatomic,strong) Class entityCellClass;

/** @abstract */
@property(nonatomic,weak) id<AKEntityListViewControllerDelegate> delegate;

///-----------------------------------------------------------------------------
/// @name Search bar
///-----------------------------------------------------------------------------

/** @abstract */
@property(nonatomic,assign) BOOL shouldShowSearchBar;

/** @abstract */
@property(nonatomic,strong) UIView *searchBarView;

///-----------------------------------------------------------------------------
/// @name Empty List Message
///-----------------------------------------------------------------------------

/** @abstract determine whether to show if a list is empty or not */
@property(nonatomic,assign) BOOL shouldShowEmptyListMessage;

/** @abstract the message to show when there are no entities in the list */
@property(nonatomic,copy) NSString* emptyListMessage;

/** @abstract an icon shown beside the empty list message */
@property(nonatomic,strong) UIImage* emptyListImageIcon;

/** @abstract a custom view to show for when a list is empty */
@property(nonatomic,strong) UIView* emptyListView;

@end