//
//  AKActorListViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-29.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

@implementation AKActorListViewController

- (void)viewDidLoad
{
    self.entityCellClass = [AKActorObjectCell class];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = HEXCOLOR(0xffffff);
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKEntityCellObject *cellObject = [self.tableModel objectAtIndexPath:indexPath];
    
    AKActorDetailViewController *detailViewController =
            [AKActorDetailViewController detailViewControllerForActor:(AKActorObject*)cellObject.entityObject];

    if ( self.navigationController ) {
        [self.navigationController pushViewController:detailViewController animated:YES];
    }    
}

@end