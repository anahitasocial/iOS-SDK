//
//  NSDictionary+AKFoundation.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-21.
//
//

#import "AKFoundation.h"

@implementation NSDictionary (AKFoundation)

- (NSDictionary*)dictionaryByMappingObjectsUsingBlock:(id(^)(id key, id obj))block
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       [newDict setValue:block(key, obj) forKey:key];
    }];
    return newDict;
}

- (NSDictionary*)dictionaryByReducingObjectsUsingBlock:(BOOL(^)(id key, id obj))block
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ( block(key, obj) )
            [newDict setValue:obj forKey:key];
    }];
    return newDict;
}

@end
