//
//  AKEntityObject.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKAbstractEntity.h"
#import "RestKit.h"

@implementation AKAbstractEntity

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping mapKeyPath:@"id" toAttribute:@"identifier"];
    return mapping;
}

@synthesize identifier = _identifier;

@end
