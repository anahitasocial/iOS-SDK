//
//  AKMapView.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
#import "AKMapView.h"
#import "AKEntityProtocols.h"
//#import "AKImageURLs.h"
#import "UIImageView+Loader.h"
#import "AKProfileViewController.h"

//AKMapView Implementation
@implementation AKMapView

@dynamic delegate;
@dynamic objects;
@synthesize shouldZoomToFitAnnotations = _shouldZoomToFitAnnotations;

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) 
    {
        _shouldZoomToFitAnnotations = YES;
        self.showsUserLocation = YES;
        _objects = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addObjectsFromResourcePath:(NSString *)resourcePath;
{
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)addObjects:(NSArray *)objects
{
    for(id<NSObject> object in objects) {
        [self addObject:object];
    }
}

- (void)addObject:(id<NSObject>)object
{
    if ( self.delegate ) {
        id<MKAnnotation> annotation = [self.delegate mapView:self annotationForObject:object];
        if ( annotation != nil ) {
            NSUInteger hash = [annotation hash];
            NSValue *key = [NSValue valueWithBytes:&hash objCType:@encode(NSUInteger)];
            [_objects setObject:object forKey:key];           
            [self addAnnotation:annotation];
        }
    }
}

#pragma mark RKObjectLoader

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error;
{
    NSLog(@"error");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects;
{
    [self addObjects:objects];
    
    if ( self.shouldZoomToFitAnnotations ) {
        [self zoomToFitAnnotations];
    }
}

- (void)zoomToFitAnnotations
{
    if ([self.annotations count] == 0) return; 
    
    CLLocationCoordinate2D topLeftCoord; 
    topLeftCoord.latitude = -90; 
    topLeftCoord.longitude = 180;             
    
    CLLocationCoordinate2D bottomRightCoord; 
    bottomRightCoord.latitude = 90; 
    bottomRightCoord.longitude = -180; 
    
    for(id<MKAnnotation> annotation in self.annotations) { 
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
    }
    
    MKCoordinateRegion region; 
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;                 
    
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

- (id)objectForAnnotation:(id<MKAnnotation>)annotation
{
    NSUInteger hash = [annotation hash];
    NSValue *key = [NSValue valueWithBytes:&hash objCType:@encode(NSUInteger)];
    return [_objects objectForKey:key];
}

- (NSArray*)objects
{
    return [_objects allValues];
}

@end

//AKMapViewAnnotation Implementation
@implementation AKMapViewAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize thumbmailURL = _thumbmailURL;

@end