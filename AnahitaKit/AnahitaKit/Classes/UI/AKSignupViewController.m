//
//  AKUIRegistrationController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-08.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKSignupViewController.h"
#import "RestKit.h"

/**
 AKUIRegistrationController conforms to the {@link NITableViewModelDelegate} and {@link UITableViewDelegate} protocols
 */
@interface AKSignupViewController() <NITableViewModelDelegate, UITableViewDelegate,
        RKObjectLoaderDelegate, UIImagePickerControllerDelegate>

- (void)showErrorAlertWithMessage:(NSString*)message;

- (BOOL)cancelSignup;
- (BOOL)startSignup;
- (BOOL)actionPickAvatar;
/**
 Returns the login controller table view model.
 */
- (NITableViewModel*)model;

@end

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

/**
 Text input IDs
 */
enum {
    kUsernameField = 100,
    kPasswordField = 101,
    kEmailField    = 102,
    kNameField     = 103
};

///-----------------------------------------------------------------------------
///
///-----------------------------------------------------------------------------

@implementation AKSignupViewController
{
    //table view model
    NITableViewModel* _model;
    
    NITableViewActions *_tableActions;
    
    //the controller view
    UITableView *_tableView;
    
    /**
     the avatar selected
     */
    UIImage *_avatar;
}

/**
 Load view replaced the original view with a table view
 */
- (void)loadView
{
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.view  = _tableView;
    _tableActions = [[NITableViewActions alloc] initWithTarget:self];
    _tableView.delegate   = _tableActions;
    _tableView.dataSource = [self model];
}

- (NITableViewModel*)model
{
    if ( !_model )
    {
        NSMutableArray* tableContents =
        [NSMutableArray arrayWithObjects:
         NSLocalizedString(@"Register", nil),
         [NITextInputFormElement textInputElementWithID:kNameField placeholderText:
          NSLocalizedString(@"Name",nil) value:nil],
         [NITextInputFormElement textInputElementWithID:kUsernameField placeholderText:
          NSLocalizedString(@"Username",nil) value:nil],
         [NITextInputFormElement textInputElementWithID:kEmailField placeholderText:
          NSLocalizedString(@"Email",nil) value:nil],
         [NITextInputFormElement passwordInputElementWithID:kPasswordField placeholderText:
          NSLocalizedString(@"Password", nil) value:nil],
         [_tableActions attachToObject:[NITitleCellObject objectWithTitle:
                                        NSLocalizedString(@"Profile Avatar",nil)] tapSelector:@selector(actionPickAvatar)],
         @"",
         nil];
        
        id object;
        
        object = [_tableActions attachToObject:[NITitleCellObject objectWithTitle:
                                       NSLocalizedString(@"Sign Up",nil)] tapSelector:@selector(startSignup)];
        
        [tableContents addObject:object];
        
        object = [_tableActions attachToObject:[NITitleCellObject objectWithTitle:
                                                NSLocalizedString(@"Cacnel",nil)] tapSelector:@selector(cancelSignup)];
        
        [tableContents addObject:object];
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents                                                         delegate:self];
    }
    
    return _model;
}

#pragma mark NITableViewModelDelegate

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object;

{
    UITableViewCell *cell = [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    
    
    return cell;
}

#pragma mark RKObjectLoaderDelegate

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ( response && response.isCreated ) {
        //if it's shown as modal then dismiss it
        NIDINFO(@"registration succeeded");
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    //if an object is returned then success
    if ( NULL != object ) {
        NIDINFO(@"signup succeeded");
        if (self.delegate && [self.delegate respondsToSelector:@selector(signupController:didRegisterPerson:)]) {
            [self.delegate signupController:self didRegisterPerson:object];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NIDINFO(@"signup failed");
    
    NSString *message = nil;

    if ( [error validationDidFailWithCode:kAKMissingValueError] ) {
        message = NSLocalizedString(@"Please make sure all the values are entered", nil);
    }
    
    else if ( [error validationDidFailForKey:@"email" code:kAKValueHasInvalidFormatError]
        ) {
        message = NSLocalizedString(@"Please enter a correct email address", nil);
    }
    else if ( [error validationDidFailForKey:@"email" code:kAKValueIsNotUniqueError]
             ) {
        message = NSLocalizedString(@"The email address you have entered is already taken. Please enter a new email address", nil);
    }
    
    else if ( [error validationDidFailForKey:@"username" code:kAKValueIsNotUniqueError]
             ) {
        message = NSLocalizedString(@"The username address you have entered is already taken. Please enter a new username", nil);
    }
    
    else if ( [error validationDidFailForKey:@"username" code:kAKValueHasInvalidFormatError]
             ) {
        message = NSLocalizedString(@"The username can only be alphanumerical values with no space", nil);
    }
    
    if ( message != nil ) {
        [self showErrorAlertWithMessage:message];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(signupController:didFailWithError:)]) {
        [self.delegate signupController:self didFailWithError:error];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)showErrorAlertWithMessage:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self
                     cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _avatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Sign up handlers

- (BOOL)actionPickAvatar
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    return YES;
}

- (BOOL)cancelSignup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(signupControllerDidCancel:)]) {
        [self.delegate signupControllerDidCancel:self];
    }
    
    return YES;
}

- (BOOL)startSignup
{
    AKPersonObject *person = [[AKPersonObject alloc] init];
    person.username = [(NITextInputFormElement*)[_model elementWithID:kUsernameField] value];
    person.password = [(NITextInputFormElement*)[_model elementWithID:kPasswordField] value];
    person.email = [(NITextInputFormElement*)[_model elementWithID:kEmailField] value];
    person.name =[(NITextInputFormElement*)[_model elementWithID:kNameField] value];
    
    if ( _avatar != NULL ) {
        [person setPortraitImage:_avatar];
    }
    
    NSError *error;
    
    if ( ![person validateValuesForKeys:@[@"username",@"password",@"email",@"name"] error:&error] ) {
        [self objectLoader:nil didFailWithError:error];
    }
    else {
        //call delegate
        if ( self.delegate && [self.delegate respondsToSelector:@selector(signupController:willRegisterPerson:)]) {
            [self.delegate signupController:self willRegisterPerson:person];
        }
        [person saveWithDelegate:self];
    }
    
    return YES;
}

@end
