//
//  Hive.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-19.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <MapKit/MapKit.h>

@class CLLocation;


@interface MKAnnotation : NSObject <MKAnnotation>

@property (nonatomic,strong) id object;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@interface ComFlyersFlyer : AKMediumObject <AKPortriableBehavior, AKVotableBehavior>

@end

@interface ComCampusesCampuse : AKActorObject
@end

@interface ComBarsBarListViewController : AKActorListViewController
@end

@interface ComCampusesListViewController : AKActorListViewController
@end

@interface ComBarsBar : AKActorObject

@property(nonatomic,strong) CLLocation *location;
@property(nonatomic,copy) NSString *address;

@end

@interface AKPersonObjectDetailViewController : AKActorDetailViewController
@end

@interface ComBarsBarHeaderView : AKActorHeaderView

@end