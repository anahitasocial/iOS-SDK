//
//  AKTableViewControllerEntityActors.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
//#import "RKTableViewCellMapping.h"
//#import "RKTableController.h"
//#import "RKTableSection.h"

#import "AKActorListTableViewController.h"
#import "AKActorProfileViewController.h"
#import "AKActorEntity.h"
#import "UIImageView+Loader.h"
#import "AKMapViewContoller.h"
#import "UIView+Subview.h"
#import <QuartzCore/QuartzCore.h>

@implementation AKActorListTableViewController

@synthesize actorClass = _actorClass;
@synthesize resourceName  = _resourceName;
@synthesize resourcePath  = _resourcePath;
@synthesize showSearchBar = _showSearchBar;

- (id)init
{
    if ( self = [super init] ) {
        _showSearchBar = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _offset = 0;
    _locked = YES;
    //initialize the table view controlller
    _tableController = [RKTableController tableControllerForTableViewController:self];    
    _tableController.objectManager = [RKObjectManager sharedManager];   
    
    if ( _resourceName != nil ) {        
        [_tableController.objectManager.mappingProvider setObjectMapping:[_actorClass objectMapping] forKeyPath:_resourceName];        
    } else {
        [_tableController.objectManager.mappingProvider setObjectMapping:[_actorClass  objectMapping]forResourcePathPattern:_resourcePath];
    }
    
    //set the delegate to this object
    _tableController.delegate = self;

    //configure cell mapping
    RKTableViewCellMapping *cellMapping = [RKTableViewCellMapping cellMapping];
//    cellMapping.cellClass = [PrettyTableViewCell class];
    
    [_tableController.cellMappings setCellMapping:cellMapping forClass:_actorClass];
    
    //load objects
    [_tableController loadTableFromResourcePath:_resourcePath];
    
    //create an empty _mappingResult
    //[_objectManager loadObjectsAtResourcePath:_resourcePath delegate:self];    

    _tableController.pullToRefreshEnabled = YES;
    
    _tableController.variableHeightRows = YES;
    
    cellMapping.rowHeight = 50;
    
    if ( _showSearchBar )
    {
        //add search
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        searchBar.backgroundColor = [UIColor clearColor];
        
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
        
        searchBar.placeholder = @"Type a search term";
        searchBar.delegate  = self;
        [_tableController sectionAtIndex:0];                
        self.tableView.tableHeaderView = searchBar;        
    }
    
    //self.tableView.backgroundColor = [UIColor colorWithHex:@"eee"];
}

#pragma mark RKTableControllerDelegate

- (void)tableController:(RKTableController *)tableController didLoadObjects:(NSArray *)objects inSection:(RKTableSection *)section
{
    _locked = NO;
    [tableController.tableView reloadData];
}
- (void)tableController:(RKTableController *)tableController willDisplayCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableView = tableController.tableView;
    NSInteger sectionsAmount = [tableView numberOfSections];
    NSInteger rowsAmount = [tableView numberOfRowsInSection:[indexPath section]];
    

    if ( !_locked )
    {
        if ([indexPath section] == sectionsAmount - 1 && [indexPath row] == rowsAmount - 1) 
        {
            _locked  = YES;
            _offset += 20;
           // NSString *path = [NSString stringWithFormat:@"%@&offset=%d", _resourcePath, _offset];
           // [_tableController loadTableFromResourcePath:_resourcePath];            
        }
    }
    
    //prepare cell
    
    RKTableViewCellMapping *mapping = [_tableController cellMappingForObjectAtIndexPath:indexPath];    
    
    AKActorEntity *actor = (AKActorEntity*)object;
    
    CGRect boxFrame   = CGRectInset(CGRectMake(0, 0, 300, mapping.rowHeight - 10), 5, 5);
    
    int height  = boxFrame.size.height;
    //int padding = boxFrame.origin.x;
    
    UIView *box  = [cell.contentView addSubviewWithTag:99 usingBlock:^UIView *{
        return [[UIView alloc] initWithFrame:boxFrame];
    }];
    
    UIImageView *imageView = (UIImageView*) [box addSubviewWithTag:100 usingBlock:^UIView *{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 5.0;
        imageView.clipsToBounds = YES;
        cell.contentView.center = imageView.center;
        return imageView;
    }];
    
    UILabel *name = (UILabel*)[box addSubviewWithTag:101 usingBlock:^UIView *{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(height + 5, 0, CGRectGetWidth(boxFrame) - CGRectGetMaxX(imageView.frame) - height, height)];
//        label.textColor = [UIColor colorWithHex:@"777"];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Arial" size:14];
        label.backgroundColor = [UIColor clearColor];
        return label;
    }];

    name.text = actor.name;
//    NSURL *imageURL = [actor.imageURLs imageURLWithImageSize:AKObjectImageSquare];
//    [imageView setImageWithURL:imageURL];

}

- (void)tableController:(RKTableController *)tableController didSelectCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    AKActorEntity *actor = (AKActorEntity*)object;
    [self.navigationController pushViewController:actor.profileViewController animated:YES];
}

#pragma mark UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *path = [NSString stringWithFormat:@"%@&q=%@", _resourcePath, searchBar.text];
    RKTableSection *section = (RKTableSection*)[_tableController sectionAtIndex:0];
    _offset = 0;
    section.objects = [NSArray array];
    [_tableController loadTableFromResourcePath:path];
}

@end
