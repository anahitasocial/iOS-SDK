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

- (id)addFormElement:(NSString*)name element:(id<AKFormElement>)element;

/** @abstract */
@property(nonatomic,readonly) NSDictionary* formValues;

/** @abstract */
@property(nonatomic,readonly) NIMutableTableViewModel *tableModel;

/** @abstract */
@property(nonatomic,readonly) NITableViewActions *tableActions;

/** @abstract */
@property(nonatomic,readonly) UITableView *tableView;

/** @abstract */
@property(nonatomic,readonly) UITableViewStyle tableViewStyle;

@end
