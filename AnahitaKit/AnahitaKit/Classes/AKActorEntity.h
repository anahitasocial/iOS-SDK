//
//  AKEntityActor.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-28.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKAbstractEntity.h"
#import "AKEntityProtocols.h"

@class RKObjectMapping;
@class AKImageURLs;
@class AKLocationAttribute;

@interface AKActorEntity : AKAbstractEntity <AKEntityPortriable, AKEntityLocatable, AKEntityDescribable, AKEntityHasProfileView, AKActorEntityFollowable>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,strong) AKImageURLs *imageURLs;
@property (nonatomic,strong) AKLocationAttribute *location;

@property (nonatomic,assign) NSUInteger followerCount;
@property (nonatomic,assign) NSUInteger leaderCount;
@property (nonatomic,assign) NSUInteger mutualCount;

@end
