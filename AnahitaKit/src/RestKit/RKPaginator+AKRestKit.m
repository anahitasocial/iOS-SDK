//
//  RKPaginator+CoreEntity.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-01-12.
//
//

#import "AKRestKit.h"

@implementation RKPaginator (CoreEntity)

- (NSUInteger)offset
{
    return self.currentPage * self.perPage;
}

@end
