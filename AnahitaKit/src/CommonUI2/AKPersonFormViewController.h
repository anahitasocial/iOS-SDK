//
//  AKUIPersonFormViewController.h
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-24.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

@class AKPersonFormViewController;

/**
 @protocol AKPersonFormViewControllerDelegate
 
 @abstract
 Provides callbacks for when a person object has been saved
 */
@protocol AKPersonFormViewControllerDelegate <NSObject>

@optional

- (void)personFormViewController:(AKPersonFormViewController*)personFormViewController
                   didSavePerson:(AKPersonObject*)person;

- (void)personFormViewController:(AKPersonFormViewController*)personFormViewController
              willSavePerson:(AKPersonObject*)person;

- (void)personFormViewControllerDidCancel:(AKPersonFormViewController*)personFormViewController;

@end

/**
 @typedef AKPersonFormFields
 
 @abstract
 Controls which fields to show 
 */
//typedef enum AKPersonFormFields {
//    kAKPersonUsernameField = 1,
//    kAKPersonNameField  = 2,
//    kAKPersonEmailField = 4,
//    kAKPersonAvatarField= 8
//    kAKActorPassword
//} AKPersonFormFields;

/**
 @class AKPersonFormViewController
 
 @abstract
 Provides a form to edit a person information. 
 */
@interface AKPersonFormViewController : UIViewController
{
    
@protected
    //table view model
    NIMutableTableViewModel   *_tableViewModel;
    NITableViewActions        *_tableActions;
    
    //the controller view
    UITableView *_tableView;
    
    /**
     the avatar selected
     */
    UIImage *_avatar;
}

/** @abstract The delegate */
@property(nonatomic,weak) id<AKPersonFormViewControllerDelegate> delegate;

/** @abstract Person object that is being edited */
@property(nonatomic,strong) AKPersonObject *personObject;

/**
 @method
 
 @abstract
 called when configuring the table view model
 */
- (void)configureTableView;

@end
