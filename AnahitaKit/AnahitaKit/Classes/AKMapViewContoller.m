//
//  AKLocationsMapViewContoller.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "RestKit.h"
#import "AKMapViewContoller.h"
#import "AKMapView.h"
#import "AKProfileViewController.h"
#import "AKEntityProtocols.h"
#import "AKImageURLs.h"
#import "UIImageView+Loader.h"

@implementation AKMapViewContoller

@synthesize locations = _locations;
@synthesize mapView = _mapView;

#pragma mark AKMapViewDelegate

- (id<MKAnnotation>)mapView:(AKMapView*)mapView annotationForObject:(id)object
{
    AKMapViewAnnotation *annotation = [[AKMapViewAnnotation alloc] init];
    
    if ( [object conformsToProtocol:@protocol(AKEntityLocatable)] ) {
        annotation.coordinate = ((id<AKEntityLocatable>)object).location.coordinate;
    }
    
    if ( [object conformsToProtocol:@protocol(AKEntityDescribable)] ) {
        annotation.title = ((id<AKEntityDescribable>)object).name;
    }
    
    if ( [object conformsToProtocol:@protocol(AKEntityPortriable)] ) {
        NSURL *imageURL = [((id<AKEntityPortriable>)object).imageURLs imageURLWithImageSize:AKObjectImageSquare];
        NSLog(@"%@", imageURL);
        // annotation.title = ((id<AKImageAttribute>)object).name;
    }
    
    return annotation;
}

- (MKAnnotationView *)mapView:(AKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if user location then return default
    
    if ( [annotation isKindOfClass:[MKUserLocation class]] ) {
        return nil;        
    }
    
	static NSString* Identifier = @"Identifier";
	
	MKPinAnnotationView *annView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
    
	if ( !annView )
	{
		annView	  = [[MKPinAnnotationView alloc] initWithAnnotation
                     :annotation reuseIdentifier:Identifier];                
	} 
    else 
    {        
		annView.annotation = annotation;
	}
    
    id object = [(AKMapView*)mapView objectForAnnotation:annotation];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];;
    button.titleLabel.text = annotation.title;    
    annView.rightCalloutAccessoryView = button;
    
    if ( [object conformsToProtocol:@protocol(AKEntityHasProfileView)] ) {
        annView.canShowCallout = YES;   
    }
    
    if ( [object conformsToProtocol:@protocol(AKEntityPortriable)] ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        NSURL *imageURL = [((id<AKEntityPortriable>)object).imageURLs imageURLWithImageSize:AKObjectImageSquare];
        [imageView setImageWithURL:imageURL];
        annView.leftCalloutAccessoryView = imageView;
    }
    
	return annView;
}

- (void)mapView:(AKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MKAnnotation> annotation = view.annotation;
    id object = [mapView objectForAnnotation:annotation];
    if (object && [object conformsToProtocol:@protocol(AKEntityHasProfileView)] ) 
    {
        AKProfileViewController *profileViewController = ((id<AKEntityHasProfileView>)object).profileViewController;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

#pragma mark View life cycle

- (void)loadView
{
    [super loadView];
    
    _mapView = [[AKMapView alloc] initWithFrame:self.view.frame];    
    _mapView.delegate = self;
    self.view = _mapView;    
}

- (AKMapView *)mapView
{
    if ( _mapView == nil ) {
        [self loadView];
    }
    return _mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.mapView.delegate = self;    
}

- (void)viewWillAppear:(BOOL)animated
{
    if ( self.mapView.shouldZoomToFitAnnotations ) {
        [self.mapView zoomToFitAnnotations];
    }    
}

- (void)viewDidUnload
{
    self.mapView.delegate = nil;    
}

@end
