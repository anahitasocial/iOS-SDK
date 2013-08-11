//
//  AKPersonEditViewController.h
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-10.
//
//

#import <UIKit/UIKit.h>
#import "AKAnahitaUI.h"

@class AKPerson;

@interface AKPersonEditViewController : UIViewController <AKFormViewController>

/**
 @method
 
 @abstract 
 Login controller
*/
- (id)initWithPerson:(AKPerson*)person;

/** @abstract */
@property(nonatomic,readonly) AKPerson *person;

@end
