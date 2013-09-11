//
//  AKPerson+Facebook.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKPerson+Facebook.h"

@implementation AKPerson (Facebook)

- (void)setOAuthToken:(AKOAuthSessionCredential*)token
{
    [self setValuesForKeysWithDictionary:[token toParameters]];
}

@end
