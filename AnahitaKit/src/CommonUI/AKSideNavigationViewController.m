//
//  AKNavigationViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-21.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKCommonUI.h"
#import "AKSideNavigationViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import <QuartzCore/QuartzCore.h>

@interface AKNavigationTableViewCell : UITableViewCell <NICell>

@end

@implementation AKNavigationTableViewCell
{
    CAGradientLayer *_cellGradient;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.textLabel.backgroundColor = [UIColor clearColor];        
        self.backgroundColor = [UIColor clearColor];
    }    
    return self;
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = @"";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (BOOL)shouldUpdateCellWithObject:(AKNavigationItem*)object
{
    self.textLabel.text  = object.title;

    if ( object.iconImage )
        self.imageView.image = object.iconImage;
    else if ( object.iconImageURL )
        [self.imageView setImageWithURL:object.iconImageURL];
    
    // TODO: Set default icon for the nav items
    
    return YES;
}

@end

#pragma mark -

@interface AKNavigationItem() <NICellObject>
@end

@implementation AKNavigationItem

- (id)init
{
    if ( self = [super init] ) {
        self.presentationStyle = AKNavigationPresentSelectedItemAsRootViewController;
    }    
    return self;
}
- (id)initWithTitle:(NSString*)title rootViewController:(UIViewController*)controller iconImage:(UIImage*)iconImage
{
    if ( self = [super init] ) {
        self.title = title;
        self.controller = controller;
        self.iconImage = iconImage;
    }    
    return self;
}

- (Class)cellClass
{
    //return a class
    return [AKNavigationTableViewCell class];
}

@end

#pragma mark -

@interface AKSideNavigationViewController () <UITableViewDelegate>

@property(nonatomic,readonly) NIMutableTableViewModel* tableModel;

@end

@implementation AKSideNavigationViewController
{
    //table model
    NIMutableTableViewModel *_tableModel;

    //table model
    UITableView *_tableView;
    
    //selected index 
    NSUInteger _selectedIndex;
    
    //content Controller
    UINavigationController *_contentController;
}

- (id)init
{
    if ( self = [super init] ) {
        _selectedIndex = 0;
        _contentController = [[UINavigationController alloc] init];
    }    
    return self;
}

- (void)addNavigationItem:(AKNavigationItem*)navigationItem
{
    [self.tableModel addObject:navigationItem toSection:0];
}

- (void)loadView
{
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self.tableModel;
    _tableView.delegate = self;
    self.view = _tableView;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor  = HEXCOLOR(0xa1a1a1);
}

- (UIViewController*)contentController
{
    if ( _contentController.viewControllers.count == 0 ) {
        AKNavigationItem *item = self.selectedNavigationItem;
        if ( item.controller ) {
            _contentController.viewControllers = @[item.controller];
        }
    }
    return _contentController;
}

- (void)viewDidLoad
{

}

- (AKNavigationItem*)selectedNavigationItem
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    AKNavigationItem *navItem = [self.tableModel objectAtIndexPath:indexPath];
    return navItem;
}

#pragma mark - 
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKNavigationItem *navItem = [self.tableModel objectAtIndexPath:indexPath];
    
    if ( navItem.onSelect ) {
        navItem.onSelect();
    }
    
    if ( navItem.controller ) {
        //lets create a navigation controller
        if ( navItem.presentationStyle == AKNavigationPresentSelectedItemAsRootViewController ) {
            [_contentController setViewControllers:@[navItem.controller]];
            if ( self.sidePanelController ) {
                if ( self.sidePanelController.state == JASidePanelLeftVisible )
                    [self.sidePanelController toggleLeftPanel:nil];
            }
        }
    }
}

#pragma mark -
#pragma mark - NIMutableTableViewModel

- (NIMutableTableViewModel*)tableModel
{
    if ( NULL == _tableModel ) {
        _tableModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
        [_tableModel addSectionWithTitle:@""];
    }
    return _tableModel;
}


@end
