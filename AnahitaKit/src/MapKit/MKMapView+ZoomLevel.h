//
//  MKMapView+ZoomLevel.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-20.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
    zoomLevel:(NSUInteger)zoomLevel
    animated:(BOOL)animated;

- (void)zoomToFit:(BOOL)animated;

@end
