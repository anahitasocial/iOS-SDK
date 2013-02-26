//
//  AKMapKitMethods.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-16.
//
//

#import "AKMapKit.h"

MKCoordinateRegion AKCoordinateRegionForCoordinates(CLLocationCoordinate2D *coords, NSUInteger coordCount)
{
    MKMapRect r = MKMapRectNull;
    for (NSUInteger i=0; i < coordCount; ++i) {
        MKMapPoint p = MKMapPointForCoordinate(coords[i]);
        r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
    }
    return MKCoordinateRegionForMapRect(r);
}