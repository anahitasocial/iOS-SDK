//
//  AKPerson+Facebook.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-13.
//
//

#import "AKConnect.h"

/**
 @category
 
 @abstract
*/
@interface AKPerson (Facebook)

/**
 @method
 
 @abstract
*/
- (void)setOAuthToken:(AKOAuthSessionCredential*)token;

@end
