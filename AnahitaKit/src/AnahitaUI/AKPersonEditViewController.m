//
//  AKPersonEditViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-10.
//
//

#import "AKPersonEditViewController.h"

enum {
    kUsernameField = 100,
    kPasswordField = 101,
    kEmailField    = 102,
    kNameField     = 103
};

@interface AKPersonEditViewController () <UIImagePickerControllerDelegate>
{

}

@property(nonatomic,readwrite) UIImage *avatar;
@end

@implementation AKPersonEditViewController

- (id)initWithPerson:(AKPerson *)person
{
    if ( self = [super init] ) {
        _person = person;
    }    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:kUsernameField placeholderText:@"Username" value:_person.username]];
    [self addFormElement:@"name" element:[NITextInputFormElement textInputElementWithID:kNameField placeholderText:@"Name" value:_person.name]];
    [self addFormElement:@"email" element:[NITextInputFormElement textInputElementWithID:kEmailField placeholderText:@"Email" value:_person.email]];
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:kPasswordField placeholderText:@"Password" value:@""]];
    [self addFormSpace];
    __weak__(self);
    [self addButton:NSLocalizedString(@"SELECT-PROFILE-PICTURE", @"Profile Picture") action:^{
        [weakself openPhotoSelector];
    }];
    
    [self addFormSpace];

    [self addButton:@"Save" action:^{        
        [weakself savePerson];       
    }];
}

- (void)openPhotoSelector
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    return YES;    
}

- (void)savePerson
{
    __weak__(self);
    [weakself.person setValuesForKeysWithDictionary:weakself.formValues];

    NSMutableURLRequest *request = [weakself.person.objectManager multipartFormRequestWithObject:weakself.person method:RKRequestMethodPOST path:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ( weakself.avatar ) {
             NSData *imageData = UIImageJPEGRepresentation(weakself.avatar, 0.9);
            [formData appendPartWithFileData:imageData
                name:@"portrait"
                fileName:@"filename" mimeType:@"image/jpg"];
        }
    }];
    
    NSIndexPath *passwordIndex = [self.tableView indexPathForCell:(UITableViewCell*)[self.tableView viewWithTag:kPasswordField]];
    NITextInputFormElement *element = [weakself.tableModel objectAtIndexPath:passwordIndex];
    element.value = @"";
    [weakself.tableView reloadRowsAtIndexPaths:@[passwordIndex] withRowAnimation:UITableViewRowAnimationNone];
    weakself.avatar = nil;
    
    RKObjectRequestOperation *operation = [weakself.person.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [weakself handleError:error];
        }];
        
        [weakself.person.objectManager enqueueObjectRequestOperation:operation];    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.avatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleError:(NSError*)error
{
    NSString *message = nil;
    if ( [error key:@"username" didFailWithCode:@"NotUnique"] ) {
        NIDPRINT(@"username is not unique");
        message =@"The username you have entered is not unique";
    }
    if ( [error key:@"email" didFailWithCode:@"NotUnique"] ) {
        NIDPRINT(@"email is not unique");
        message =@"The email you have entered is not unique";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The following error occured" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
