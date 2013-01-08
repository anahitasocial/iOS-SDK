//
//  AKPerson.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKPerson : NSObject

@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,readonly,getter = id) NSNumber *entityId;

@end
