//
//  AKUIPersonFormViewController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-11-24.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "AKPersonFormViewController.h"
#import "RestKit.h"

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

@interface AKPersonFormViewController () <NITableViewModelDelegate, UITableViewDelegate,
                AKEntityObjectDelegate, UIImagePickerControllerDelegate,
                UIActionSheetDelegate
                >

- (BOOL)actionSave;
- (BOOL)actionCancel;
- (BOOL)actionSelectAvatar;

@end

@implementation AKPersonFormViewController  

/**
 Load view replaced the original view with a table view
 */
- (void)loadView
{
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.backgroundView  = [[UIView alloc] initWithFrame:_tableView.bounds];
    _tableView.backgroundView.backgroundColor = HEXCOLOR(0xf1f1f1);    
    self.view  = _tableView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //load the person
    if ( nil == _personObject ) {
        [self configureTableView];
    }
    else {
        [self configureTableView];
        [self.personObject loadWithDelegate:self];
    }
}

- (void)configureTableView
{
    
    _tableActions   = [[NITableViewActions alloc] initWithTarget:self];

    
    NSMutableArray* tableContents =
    [NSMutableArray arrayWithObjects:
     NSLocalizedString(@"Edit", nil),
     [NITextInputFormElement textInputElementWithID:kNameField placeholderText:
      NSLocalizedString(@"Name",nil) value:self.personObject.name],
     [NITextInputFormElement textInputElementWithID:kUsernameField placeholderText:
      NSLocalizedString(@"Username",nil) value:self.personObject.username],
     [NITextInputFormElement textInputElementWithID:kEmailField placeholderText:
      NSLocalizedString(@"Email",nil) value:self.personObject.email],
     [NITextInputFormElement passwordInputElementWithID:kPasswordField placeholderText:
      NSLocalizedString(@"Password", nil) value:nil],
     
     [_tableActions attachToObject:[NITitleCellObject objectWithTitle:
                                    NSLocalizedString(@"Avatar",nil) image:_avatar] tapSelector:@selector(actionSelectAvatar)],
     @"",
     nil];
    
    id object;
    
    object = [_tableActions attachToObject:[AKButtonCellObject objectWithTitle:
                                            NSLocalizedString(@"Save",nil)] tapSelector:@selector(actionSave)];
    
    [tableContents addObject:object];
    
    if ( self.presentingViewController ) {
        object = [_tableActions attachToObject:[AKButtonCellObject objectWithTitle:
                                            NSLocalizedString(@"Cancel",nil)] tapSelector:@selector(actionCancel)];
        [tableContents addObject:object];        
    }

    
    _tableViewModel = [[NIMutableTableViewModel alloc] initWithSectionedArray:tableContents delegate:self];
    _tableView.delegate   = _tableActions;
    _tableView.dataSource = _tableViewModel;
    
}

#pragma mark - 
#pragma TableView Action Handlers

- (BOOL)actionSave
{    
    self.personObject.username = [(NITextInputFormElement*)[_tableViewModel elementWithID:kUsernameField] value];
    self.personObject.password = [(NITextInputFormElement*)[_tableViewModel elementWithID:kPasswordField] value];
    self.personObject.email = [(NITextInputFormElement*)[_tableViewModel elementWithID:kEmailField] value];
    self.personObject.name =[(NITextInputFormElement*)[_tableViewModel elementWithID:kNameField] value];
    
    if ( _avatar != NULL ) {
        [self.personObject setPortraitImage:_avatar];
    }
    
    NSError *error;
    
    if ( false && ![self.personObject validateValuesForKeys:@[@"username",@"email",@"name"] error:&error] ) {
        [self objectLoader:nil didFailWithError:error];
    }
    else {
        //call delegate
        if ( self.delegate && [self.delegate respondsToSelector:@selector(personFormViewController:willSavePerson:)]) {
            [self.delegate personFormViewController:self willSavePerson:self.personObject];
        }
        [self.personObject saveWithDelegate:self];
    }
    
    return YES;
}

- (BOOL)actionCancel
{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(personFormViewControllerDidCancel:)] ) {
        [self.delegate personFormViewControllerDidCancel:self];
    }
    
    //if presented as modal then lets close it
    if ( self.presentingViewController != nil ) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    return NO;
}

- (BOOL)actionSelectAvatar
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Use an existing photo", nil];
    
    [actionSheet showInView:self.view];

    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ( buttonIndex == 0 ) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 
#pragma mark NITableViewModelDelegate

- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object;

{
    UITableViewCell *cell = [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    
    
    return cell;
}

//if person object is not set then return a default person object
- (AKPersonObject*)personObject
{
    if ( nil == _personObject) {
        _personObject = [AKPersonObject new];
    }
    return _personObject;
}

#pragma mark - 
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{

}
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"%@", response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    //if an object is returned then success
    if ( NULL != object ) {
        //if saved succesfully
        if ( objectLoader.response.statusCode == 205 || objectLoader.response.isCreated ) {
            if ( self.delegate && [self.delegate respondsToSelector:@selector(personFormViewController:didSavePerson:)]) {
                [self.delegate personFormViewController:self didSavePerson:object];
            }
    
            //if presented as modal then lets close it
            if ( self.presentingViewController != nil ) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
    
        } else {
            [self configureTableView];
            [_tableView reloadData];
        }
    }
}

- (void)requestWillPrepareForSend:(RKRequest *)request
{
    if ( request.isGET ) {
        
    }
}

- (void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response
{
    
}

- (void)entityObject:(AKEntityObject *)entityObject didFailValidation:(NSError *)error
{
    NIDINFO(@"save failed");
    
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
    
    else if ( [error validationDidFailForKey:@"password" code:kAKValueHasInvalidFormatError] ) {
        message = NSLocalizedString(@"Please pick a stronger password", nil);    
    }
    
    if ( message != nil ) {
        AKUIAlertViewShowAlert(@"Error", message);
    }        
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _avatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
    //geting the avatar object
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.imageView.image = _avatar;    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
