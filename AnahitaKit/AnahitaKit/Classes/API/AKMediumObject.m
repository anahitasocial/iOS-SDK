//
//  AKMediumObject.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-12-02.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKMediumObject.h"

@implementation AKMediumObject

+ (void)configureObjectEntity:(AKEntityConfiguration *)configuration
{
    [super configureObjectEntity:configuration];
    [configuration mapAttributes:@"title",@"body", nil];
    [configuration.objectMapping mapRelationship:@"author" toObjectClass:[AKPersonObject class]];
    [configuration.objectMapping mapRelationship:@"editor" toObjectClass:[AKPersonObject class]];    
}

@end


@implementation AKPostObject @end

@implementation AKPhotoObject @end