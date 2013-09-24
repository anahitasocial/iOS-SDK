//
//  AKCommonUIMixins.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-14.
//
//

#import "AKFoundation.h"

@class NIDOM;
@class NIMutableTableViewModel;
@class NITableViewActions;
@class UITableView;
@class NIFormElement;
@class NIStylesheet;

typedef NIFormElement*(^FormElementBlock)(NSInteger elementID);

@protocol AKFormViewController <AKBehavior>

@optional

/**
 @method

 @abstract
*/
- (void)addFormSpace;

/**
 @method

 @abstract
*/
- (id)addButton:(NSString*)title action:(void(^)())actionBlock;

/**
 @method

 @abstract
*/
- (id)addFormElement:(NSString*)name element:(id<AKFormElement>)element;

/**
 @method

 @abstract
*/
- (id)addObject:(id<NICellObject>)object;

/**
 @method

 @abstract
*/
- (id)addObject:(id<NICellObject>)object detailAction:(NITableViewActionBlock)actionBlock;

/**
 @method

 @abstract
*/
- (id)addObject:(id<NICellObject>)object navgiationAction:(NITableViewActionBlock)actionBlock;

/**
 @method

 @abstract
*/
- (id)addObject:(id<NICellObject>)object tapAction:(NITableViewActionBlock)actionBlock;

/** @abstract */
@property(nonatomic,readonly) NSDictionary* formValues;

/** @abstract */
@property(nonatomic,readonly) NIMutableTableViewModel *tableModel;

/** @abstract */
@property(nonatomic,readonly) NITableViewActions *tableActions;

/** @abstract */
@property(nonatomic,readonly) UITableView *tableView;

/** @abstract */
@property(nonatomic,assign) UITableViewStyle tableViewStyle;

@end
