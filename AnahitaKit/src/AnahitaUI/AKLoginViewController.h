//
//  AKLoginViewController.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import <UIKit/UIKit.h>
#import "AKAnahitaUI.h"

@class AKSession;

/**
 @class
 
 @abstract 
 Login controller
*/
@interface AKLoginViewController : UIViewController <AKFormViewController>

/**
 @method
 
 @abstract 
 Login controller
*/
- (id)initWithSession:(AKSession*)session;

/** @abstract */
@property(nonatomic,readonly) AKSession *session;

@end
