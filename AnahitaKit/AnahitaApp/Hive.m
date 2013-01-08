//
//  Hive.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "Hive.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"

@implementation AKPersonObjectDetailViewController


- (UITableView*)mainContentView
{
    AKEntityListViewController *listController = [AKEntityListViewController new];
//    listController.objectLoader = [ComFlyersFlyer loaderWithQuery:[NSString stringWithFormat:@"voterId=%d",self.entityObject.identifier.intValue]];
    listController.shouldShowSearchBar = NO;
    listController.objectPaginator = [ComFlyersFlyer paginatorWithQuery:[NSString stringWithFormat:@"voterId=%d",self.entityObject.identifier.intValue]];
    listController.entityCellClass = [AKMediumObjectCell class];
    [self addChildViewController:listController];
    return listController.tableView;
}

@end

@implementation ComFlyersFlyer


@end

@interface ComBarsBarMapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,strong) NSArray *bars;
@property(nonatomic,strong) UIViewController *barsController;

@end

@implementation ComBarsBarMapViewController
{
    MKMapView *_mapView;
}
- (void)loadView
{
    [super loadView];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    self.view = _mapView;
}

- (void)viewDidLoad
{
    //add all annotatoins
    [self.bars enumerateObjectsUsingBlock:^(ComBarsBar *obj, NSUInteger idx, BOOL *stop) {
        MKAnnotation *annotation = [MKAnnotation new];
        annotation.object = obj;
        annotation.coordinate = obj.location.coordinate;
        annotation.title = obj.name;
        [_mapView addAnnotation:annotation];
    }];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(49.32288427945948,  -123.10867309570312) zoomLevel:11 animated:YES];
}

#pragma mark - 
#pragma mark - MKMapViewDelegate 

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(MKAnnotation*)annotation
{
    static NSString* mapIdentifier = @"mapIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:mapIdentifier];
    if ( !annotationView ) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapIdentifier];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
    [imageView setImageWithURL:[[annotation.object imageURL] imageURLWithImageSize:kAKSquareImageURL]];
    annotationView.leftCalloutAccessoryView  = imageView;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id object = [view.annotation performSelector:@selector(object)];
    AKActorDetailViewController *detailViewController = [AKActorDetailViewController detailViewControllerForActor:object];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.barsController.navigationController pushViewController:detailViewController animated:YES];
    }];

}

@end

@implementation ComBarsBarListViewController

- (void)didLoadEntities:(NSArray *)entities
{
    [super didLoadEntities:entities];
    
    if ( self.entities.count > 0 ) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kAKMapBarButtonIcon style:UIBarButtonItemStyleBordered target:self action:@selector(showMapView)];
    }
}

- (void)showMapView
{
    ComBarsBarMapViewController *controller = [ComBarsBarMapViewController new];
    controller.bars = self.entities;
    controller.barsController = self;
    [controller setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:controller animated:YES completion:nil];
}

@end

@implementation ComCampusesListViewController

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComCampusesCampuse *campuse = (ComCampusesCampuse*)[[self.tableModel objectAtIndexPath:indexPath] entityObject];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ( [campuse canUnfollow] ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKEntityCellObject *cellObject = [self.tableModel objectAtIndexPath:indexPath];
    
    AKActorObject *entityObject = (AKActorObject*)cellObject.entityObject;
    
    //lets follow after a sele
    if ( entityObject.isLeader )
        [AKSessionObject.viewer unfollow:entityObject onSuccess:nil onFailure:nil];
    else
        [AKSessionObject.viewer follow:entityObject onSuccess:nil onFailure:nil];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end

@implementation ComCampusesCampuse

+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    [configuration.objectMapping mapAttributes:@"location",@"address", nil];
}

@end

@implementation ComBarsBar

+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    [configuration.objectMapping mapAttributes:@"location",@"address", nil];
}

@end



@implementation MKAnnotation @end

@interface ComBarsBarHeaderView()

@property(nonatomic,readonly) ComBarsBar *actorObject;

@end

#import <QuartzCore/QuartzCore.h>

@implementation ComBarsBarHeaderView
{
    MKMapView *_mapView;
    BOOL _enlargedMap;
}

- (id)initWithFrame:(CGRect)frame
{
    //frame = CGRectSetHeight(frame, 100 + 100 + 10);
    
    if (self = [super initWithFrame:frame]) {
        //lets add a map view
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];        
        [_mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMapView:)]];
        [self addSubview:_mapView];
        _enlargedMap = NO;
        _mapView.layer.shadowColor = HEXCOLOR(0x000000).CGColor;
        _mapView.layer.shadowOpacity = 0.7;
        _mapView.layer.shadowRadius  = 0.5;
        _mapView.layer.shadowOffset  = CGSizeMake(0,1);
        _mapView.layer.masksToBounds = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _mapView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.frame), _enlargedMap ? 400 : 100);

    self.bounds = CGRectSetHeight(self.bounds, CGRectGetMaxY(_mapView.frame));
    [(UITableView *)self.superview setTableHeaderView:self];    
    MKAnnotation *annotation = [MKAnnotation new];

    annotation.coordinate = self.actorObject.location.coordinate;
    annotation.title = self.actorObject.address;
    annotation.subtitle = @"";
    [_mapView setCenterCoordinate: self.actorObject.location.coordinate zoomLevel:14 animated:YES];
    _mapView.zoomEnabled = NO;
    [_mapView addAnnotation:annotation];
}

- (void)didTapMapView:(id)sender
{
    UITableView *superView = (UITableView*)self.superview;    
    _enlargedMap = !_enlargedMap;
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectSetHeight(self.frame, _enlargedMap ? 400 : 210);        
    } completion:^(BOOL finished) {
        [superView setTableHeaderView:self];
    }];
}

@end