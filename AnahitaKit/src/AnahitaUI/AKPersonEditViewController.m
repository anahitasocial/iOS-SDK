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
    [self.tableView addStyleTag:@"SignupTableView"];
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:kUsernameField placeholderText:@"Username" value:_person.username]];
    [self addFormElement:@"name" element:[NITextInputFormElement textInputElementWithID:kNameField placeholderText:@"Name" value:_person.name]];
    [self addFormElement:@"email" element:[NITextInputFormElement textInputElementWithID:kEmailField placeholderText:@"Email" value:_person.email]];
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:kPasswordField placeholderText:@"Password" value:@""]];
    [self addFormSpace];
    __weak__(self);
 
    
    [self addFormSpace];

    [self addButton:@"Save" action:^{        
        [weakself savePerson];       
    }];
}


- (void)savePerson
{
    __weak__(self);
    [self.person setValuesForKeysWithDictionary:weakself.formValues];
    
    //reset the password field
    NSIndexPath *passwordIndex = [self.tableView indexPathForCell:(UITableViewCell*)[self.tableView viewWithTag:kPasswordField]];
    NITextInputFormElement *element = [self.tableModel objectAtIndexPath:passwordIndex];
    element.value = @"";
    
    [self.person save:^{
        
    } failure:^(NSError *error) {
        [weakself handleError:error];
    }];            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
