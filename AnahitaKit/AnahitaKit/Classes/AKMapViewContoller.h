//
//  AKLocationsMapViewContoller.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <MapKit/MapKit.h>    
#import "AKEntityListTableViewController.h"
#import "AKMapView.h"

@class CLLocation;
@class AKMapView;

@interface AKMapViewContoller : UIViewController <AKMapViewDelegate>
{

}

//an array of locations to show
//these location must conform
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, readonly,strong) AKMapView *mapView;

@end
