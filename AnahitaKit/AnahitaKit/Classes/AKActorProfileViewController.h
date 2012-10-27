//
//  AKViewControllerActor.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKProfileViewController.h"


@class AKActorEntity;

@interface AKActorProfileViewController : AKProfileViewController

@property (nonatomic,strong,setter = setProfileObject:,getter = profileObject) AKActorEntity *actor;

@end
