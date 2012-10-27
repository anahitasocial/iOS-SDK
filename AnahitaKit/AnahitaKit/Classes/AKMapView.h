
//
//  AKMapView.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 12-09-03.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "Vendors/RestKit.h"

@class AKMapView;

/**
 *
 * AKMapViewDelegate
 *
 */
@protocol AKMapViewDelegate <MKMapViewDelegate>

@optional

//Returns an annotation object for an object
- (id<MKAnnotation>)mapView:(AKMapView*)mapView annotationForObject:(id)object;

@end
    
/**
 *
 * AKMapView
 *
 */
@interface AKMapView : MKMapView <RKObjectLoaderDelegate>
{
 
@protected
    NSMutableDictionary *_objects;
}

@property (nonatomic,assign) id<AKMapViewDelegate> delegate;
@property (nonatomic,assign) BOOL shouldZoomToFitAnnotations;
@property (nonatomic,readonly,strong) NSArray *objects;

//zoom into a region of annotations
- (void)zoomToFitAnnotations;

//return the entity object for annotation
- (id)objectForAnnotation:(id<MKAnnotation>)annotation;

//add an entity
- (void)addObject:(id<NSObject>)object;

//add an array of entities
- (void)addObjects:(NSArray*)objects;

//load map data from resource path
- (void)addObjectsFromResourcePath:(NSString *)resourcePath;

@end

@interface AKMapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSURL *thumbmailURL;

@end   