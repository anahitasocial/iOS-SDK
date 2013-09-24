//
//  AKLoginViewController.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import <UIKit/UIKit.h>
#import "AKAnahitaUI.h"

@class FBSession;
@class AKSession;

/**
 @class
 
 @abstract 
 Login controller
*/
@interface AKLoginViewController : UIViewController <AKFormViewController>


@end

extern NSString * const kAKServiceDidAuthorizeWithoutMathhingAccount;
