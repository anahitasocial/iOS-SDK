//
//  AKQElement.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Vendors/QuickDialog.h"

@class AKQElement;

@protocol AKQElementDelegate <NSObject>

@optional

- (void)element:(AKQElement*)element prepareCell:(UITableViewCell*)cell forTableView:(QuickDialogTableView*)tableView;

- (int)element:(AKQElement*)element cellHeightForTableView:(QuickDialogTableView*)tableView;

- (UITableViewCell*)element:(AKQElement*)element cellForTableView:(QuickDialogTableView*)tableView;

@end

@interface AKQElement : QElement
{

}

- (QElement *)initWithKey:(NSString *)key delegate:(id<AKQElementDelegate>)delegate;

@property(nonatomic, copy) UITableViewCell* (^cellForTableView)(AKQElement *element, QuickDialogTableView* tableView);

@property(nonatomic, copy) void (^prepareCellForTableView)(AKQElement*, UITableViewCell*,QuickDialogTableView*);

@property(nonatomic, copy) NSUInteger (^cellHeightUsingBlock)(AKQElement*,QuickDialogTableView*);

@property(nonatomic, strong) id<AKQElementDelegate> delegate;

@property(nonatomic, assign) NSUInteger cellHeight;

@end
