//
//  AKQElement.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-06.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKQElement.h"
#import "Vendors/PrettyKit.h"

@implementation AKQElement

@synthesize prepareCellForTableView = _prepareCellForTableView;
@synthesize delegate = _delegate;
@synthesize cellHeight = _cellHeight;
@synthesize cellForTableView = _cellForTableView;
@synthesize cellHeightUsingBlock = _cellHeightUsingBlock;

- (id)init
{
    if ( self = [super init] ) 
    {
        //set the default cell height to 44
        _cellHeight = 44;
    }
    
    return self;
}

- (QElement *)initWithKey:(NSString *)key delegate:(id<AKQElementDelegate>)delegate
{
    if ( self = [super initWithKey:key] ) {
        self.delegate = delegate;
    }
    
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller 
{
    UITableViewCell *cell = nil;
     
    if ( self.cellForTableView ) {
        cell = self.cellForTableView(self, tableView);
    }
    
    
    if ( cell == nil )
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(element:cellForTableView:)] ) {
            cell = [self.delegate element:self cellForTableView:tableView];
        }
        
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"QuickformElementCell%@", self.key]];
            
            if (cell == nil) 
            {
                cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"QuickformElementCell%@", self.key]];
                
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showsReorderControl = YES;
    cell.accessoryView = nil;
  
    if ( self.delegate && [self.delegate respondsToSelector:@selector(element:prepareCell:forTableView:)])
    {
        [self.delegate element:self prepareCell:cell forTableView:tableView];
    }
    
    if (self.prepareCellForTableView ) {
        self.prepareCellForTableView(self, cell, tableView);
    }

    return cell;
}

- (CGFloat)getRowHeightForTableView:(QuickDialogTableView *)tableView;
{
    int height = self.cellHeight;
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(element:cellHeightForTableView:)] ) {
        height = [self.delegate element:self cellHeightForTableView:tableView];
    }
    
    if ( self.cellHeightUsingBlock ) {
        height = self.cellHeightUsingBlock(self, tableView);
    }
    
    return height;
}

@end
