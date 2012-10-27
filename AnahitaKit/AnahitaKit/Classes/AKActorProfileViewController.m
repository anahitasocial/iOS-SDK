//
//  AKViewControllerActor.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

#import "AKActorProfileViewController.h"
#import "AKImageURLs.h"
#import "AKActorEntity.h"
#import "AKActorListTableViewController.h"

#import "UIImageView+Loader.h"
#import "Vendors/PrettyKit.h"
#import "Vendors/SSDrawingUtilities.h"
#import "Vendors/UIColor+SSToolkitAdditions.h"
#import "Vendors/RKTableViewCellMapping.h"
#import "Vendors/RKTableController.h"
#import "Vendors/RKTableViewCellMapping.h"
#import "Vendors/RKObjectMapping.h"

@implementation AKActorProfileViewController

@synthesize actor;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //draw actor info
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
    cellMapping.cellClass = [PrettyTableViewCell class];
    cellMapping.rowHeight   = 200;
    cellMapping.reuseIdentifier = @"ActorInfo";
    cellMapping.onCellWillAppearForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
        [(PrettyTableViewCell*)cell prepareForTableView:self.tableView indexPath:indexPath];
        int padding = 5;       
        int width   = 290;
        int height  = 190;
        int avatar  = 60;
                
        //create a box with 5 point padding
        CGRect box  =  CGRectInset(CGRectMake(0, 0, width, height), 5, 5) ;
        
        UIView* contentView = [[UIView alloc] initWithFrame:box]; 
        [cell.contentView addSubview:contentView];
        
        UIImageView *avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatar,avatar)];
        
        [avatarImage setImageWithURL:[self.actor.imageURLs imageURLWithImageSize:AKObjectImageSquare]];
        avatarImage.layer.cornerRadius = 5.0;
        avatarImage.layer.masksToBounds = YES;
        avatarImage.layer.borderColor = [UIColor colorWithHex:@"eee"].CGColor;        
        
        
        UILabel *nameLabel = [[UILabel alloc] 
                              initWithFrame:CGRectMake(CGRectGetMaxX(avatarImage.frame) + padding,0,CGRectGetWidth(box) - avatar - padding,avatar)];
        
        
        nameLabel.font  = [UIFont fontWithName:@"Arial-BoldMT" size:17];    
        
        nameLabel.text  = self.actor.name;
        nameLabel.textColor = [UIColor colorWithHex:@"777"];
        nameLabel.numberOfLines = 0;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        CGRect descLabelFrame = CGRectMake(0, CGRectGetMaxY(avatarImage.frame) + padding , CGRectGetWidth(box),CGRectGetHeight(box) - CGRectGetMaxY(avatarImage.frame) - padding);
        
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:descLabelFrame];
        
        descLabel.text = actor.body;
        descLabel.font = [UIFont fontWithName:@"Arial" size:14];
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor colorWithHex:@"999"];
        descLabel.backgroundColor = [UIColor clearColor];
        [contentView addSubview:descLabel];
        [contentView addSubview:avatarImage];        
        [contentView addSubview:nameLabel];
    };
        
    [_tableController loadObjects:[NSArray arrayWithObject:[RKTableItem tableItemWithCellMapping:cellMapping]]];
    

    RKTableSection *section = [RKTableSection section];
    
    
    cellMapping = [RKTableViewCellMapping defaultCellMapping];
    cellMapping.reuseIdentifier = @"ActorActions";    
    cellMapping.cellClass = [PrettyTableViewCell class];
    cellMapping.onCellWillAppearForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
        [(PrettyTableViewCell*)cell prepareForTableView:self.tableView indexPath:indexPath];  
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    cellMapping.onSelectCellForObjectAtIndexPath = ^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
        AKActorListTableViewController *actorlist = [[AKActorListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        actorlist.actorClass = [AKActorEntity class];
        if ( actor.class != [AKActorEntity class] )
            actorlist.resourcePath = [NSString stringWithFormat:@"option=com_bars&view=bar&id=%d&get=graph&type=followers", [actor.identifier intValue]];
        else
            actorlist.resourcePath = [NSString stringWithFormat:@"option=com_people&view=person&id=%d&get=graph&type=followers", [actor.identifier intValue]];
        
        actorlist.title = @"Followers";
        [self.navigationController pushViewController:actorlist animated:YES];
        
    };
    
    RKTableItem *item = [RKTableItem tableItemWithCellMapping:cellMapping];
    item.text = [NSString stringWithFormat:@"%d Followers", actor.followerCount];
    
    section.objects = [NSMutableArray arrayWithObject:item];
    
    
    [_tableController addSection:section];
    
    self.navigationItem.title = self.actor.name;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark QuickDialogStyleProvider

#pragma mark RKTableControllerDelegate

- (void)tableController:(RKTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
