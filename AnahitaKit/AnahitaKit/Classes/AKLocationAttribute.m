//
//  AKObjectLocation.m
//  Anahita
//
//  Created by Arash  Sanieyan on 12-08-30.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKLocationAttribute.h"

@implementation AKLocationAttribute

- (id)initWithMappableValue:(id)mappableValue
{
    return [super initWithLatitude:[[mappableValue valueForKey:@"latitude"] doubleValue] longitude:[[mappableValue valueForKey:@"longitude"] doubleValue]];
}

@end
