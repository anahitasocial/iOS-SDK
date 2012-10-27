//
//  AKEntityObject.h
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class RKObjectMapping;

@interface AKAbstractEntity : NSObject

+ (RKObjectMapping *)objectMapping;

@property(nonatomic,strong) NSNumber *identifier;

@end
