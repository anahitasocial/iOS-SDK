//
//  AKCoreCellCatalogs.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class NIAttributedLabel;

/**
 @class AKCellObjectForEntityObject
 
 @abstract
 A generic entity cell object. It contains the entity
 
 */
@interface AKEntityCellObject : NICellObject

/**
 @method
 
 @abstract
 Initializes a generic cell entity object
*/
- (id)initWithEntityObject:(AKEntityObject*)entityObject
        cellClass:(Class)cellClass
        cellActions:(NSArray*)cellActions
        ;

/** @abstract Entity object */
@property(nonatomic,readonly) AKEntityObject* entityObject;

/** @abstract cell actions */
@property(nonatomic,readonly) NSArray* cellActions;

@end

#pragma mark - 

/**
 @class AKEntityObjectCell
 
 @abstract 
*/
@interface AKEntityObjectCell : UITableViewCell <NICell>
{
    AKEntityCellObject *_cellObject;
}
/** @abstract Cell delegate */
@property(nonatomic,weak) id<AKViewNotificationDelegate> notificationDelegate;

@end

#pragma mark - 

/**
 @class AKMediumObjectCell
 
 @abstract 
*/
@interface AKActorObjectCell : AKEntityObjectCell

@end

#pragma mark - 

/**
 @struct 
 
 @abstract
 Metrics for medium cell elements
*/
typedef struct AKMediumCellElementMetrics {

  //avatar size
  CGSize avatarSize;
  
  //cell padding
  UIEdgeInsets cellPadding;
  
  //content padding
  UIEdgeInsets contentPadding;
  
  //action box height
  CGFloat actionsBoxHeight;
  
} AKMediumCellElementMetrics;

/**
 @struct 
 
 @abstract
 Metrics for an entity being diplayed in a medium cell
*/
typedef struct AKMediumCellEntityMetrics {
    
    //height of text
    CGFloat textHeight;
    
    //height of media
    CGFloat mediaHeight;
    
} AKMediumCellEntityMetrics;

/**
 @class AKMediumObjectCell
 
 @abstract 
*/
@interface AKMediumObjectCell : AKEntityObjectCell
{

}

/**
 @method
 
 @abstract
 Return the element metrics. Subclasses can change these or use them
 to furhter position their data

 @return 
*/
+ (AKMediumCellElementMetrics)cellElementsMetrics;

/**
 @method
 
 @abstract

 @return
*/
+ (AKMediumCellEntityMetrics)entityMetrics:(id)entity constrainedToContentWidth:(CGFloat)contentWidth
        cellWidth:(CGFloat)cellWidth;

/** @abstract Return a rect that represents the drawable area of the cell */
@property(nonatomic,readonly) CGRect contentRect;

/** @abstract Return a rect that represents the drawable area of the cell for action*/
@property(nonatomic,readonly) CGRect actionRect;

/** @abstract the cell body label */
@property(nonatomic,readonly) NIAttributedLabel *bodyLabel;

/** @abstract the cell title label */
@property(nonatomic,readonly) NIAttributedLabel *titleLabel;

/** @abstract like button */
@property(nonatomic,readonly) UIButton *likeButton;

/** @abstract the cell action label */
@property(nonatomic,readonly) NIAttributedLabel *actionLabel;

/** @abstract the cell content image view */
@property(nonatomic,readonly) UIImageView *contentImageView;

/**
 @method
 
 @abstract
 Set the cell thumbnail using an entity object
*/
- (void)setCellThumbnail:(AKEntityObject*)entityObject;

/**
 @method
 
 @abstract
 Set the cell title using an entity object
*/
- (void)setCellTitle:(AKEntityObject*)entityObject;

/**
 @method
 
 @abstract
 Set the cell body using an entity object
*/
- (void)setCellBody:(AKEntityObject*)entityObject;

/**
 @method
 
 @abstract
 Set the cell actions using an entity object
*/
- (void)setCellActions:(AKEntityObject*)entityObject;

/**
 @method
 
 @abstract
*/
- (void)layoutContentForEntity:(AKEntityObject*)entityObject;


/**
 @method
 
 @abstract
 Return the height based on the content of an entity object
*/
+ (CGFloat)heightForEntityObject:(AKEntityObject*)entityObject
            atIndexPath:(NSIndexPath *)indexPath
            tableView:(UITableView *)tableView;

@end

#pragma mark - 

@interface AKMediumObjectDetailViewCell : AKMediumObjectCell

@end

#pragma mark - 

/**
 @class AKStoryObjectCell
 
 @abstract
 story cell class
*/
@interface AKStoryObjectCell : AKMediumObjectCell @end

#pragma mark - 

/**
 @class AKButtonCell
 
 @abstract
*/
@interface AKButtonCell : UITableViewCell<NICell> @end

@interface AKButtonCellObject : NITitleCellObject @end
