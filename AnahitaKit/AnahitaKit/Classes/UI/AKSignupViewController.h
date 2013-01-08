//
//  AKUIRegistrationController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-08.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKSignupViewController;

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

/**
 Communicates the signup process with a delegate object
 */
@protocol AKSignupViewControllerDelegate <NSObject>

@required

/**
 called after a success sign up
 */
- (void)signupController:(AKSignupViewController*)signupController didRegisterPerson:(AKPersonObject*)person;

@optional

/*
 called before registering a person
 */
- (void)signupController:(AKSignupViewController*)signupController willRegisterPerson:(AKPersonObject*)person;

/**
 called after a failed signup
 */
- (void)signupController:(AKSignupViewController*)signupController didFailWithError:(NSError*)error;

/**
 called after a cancelled signup
 */
- (void)signupControllerDidCancel:(AKSignupViewController*)signupController;

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

/**
 Registration controller registers a user
 */
@interface AKSignupViewController : UIViewController

/**
 Delegate property
 */
@property(nonatomic,weak) id<AKSignupViewControllerDelegate> delegate;

@end
