//
//  AKLoginController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//


@class AKLoginViewController;
@class AKOAuthConsumer;

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

/**
 Communicates the login process with a delegate object
 */
@protocol AKLoginViewControllerDelegate <NSObject>

@required

/**
 called after a success sign up
 */
- (void)loginController:(AKLoginViewController*)loginController didLoginPerson:(AKPersonObject*)person;

@optional

/**
 called after a failed signup
 */
- (void)loginController:(AKLoginViewController*)loginController didFailWithError:(NSError*)error;

@end

/**
 Login controller presents a login form for the user
 */
@interface AKLoginViewController : UIViewController

/** @abstract login header view */
@property(nonatomic,strong) UIView *headerView;

/** @abstract login header image */
@property(nonatomic,strong) UIImage *headerImage;

/**
 If set to true it allows the user to register. By default it sets to true
 */
@property(nonatomic,assign) BOOL canRegister;

/**
 Login delegate 
 */
@property(nonatomic,weak) id<AKLoginViewControllerDelegate> delegate;

///-----------------------------------------------------------------------------
/// Authentication through oAuth services
///-----------------------------------------------------------------------------

@property(nonatomic,strong) AKOAuthConsumer *twitterConsumer;
@property(nonatomic,assign) AKOAuthConsumer *facebookConsumer;

@end