//
//  AKObjectMappings.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-27.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"

@implementation AKObjectMapping

- (void)mapRelationship:(NSString*)relationship toObjectClass:(Class)class
{
    id klass = (id)class;
    [self mapRelationship:relationship withMapping:[klass sharedConfiguration].objectMapping];
}

#pragma mark - 
#pragma mark - Override NSObject

- (BOOL)isKindOfClass:(Class)aClass
{
    if ( aClass == [RKDynamicObjectMapping class] ) {
        return YES;
    }
    return [super isKindOfClass:aClass];
}

//reutrn a mapping
- (RKObjectMapping*)objectMappingForDictionary:(NSDictionary*)mappableData
{
    NSString *objectType = [mappableData valueForKey:@"objectType"];
    id class;
    if ( NULL != objectType )
    {        
        NSArray *parts       = [objectType componentsSeparatedByString:@"."];
        
        //find a class
        class = AKNSClassFromListOfStrings(
        
            [[parts arrayByMappingObjectsUsingBlock:^(id obj, NSUInteger idx) {
                return [obj capitalizedString];
            }] componentsJoinedByString:@""],
        
            [NSString stringWithFormat:@"AK%@Object", [[parts objectAtIndex:2] capitalizedString]],
        
            self.objectClass,NULL
        );
        
//        NIDPRINT(@"Found a class %@ for object type %@",class,objectType);
        
    } else {
        class = self.objectClass;
    }
    
    return [class sharedConfiguration].objectMapping;
}

@end
