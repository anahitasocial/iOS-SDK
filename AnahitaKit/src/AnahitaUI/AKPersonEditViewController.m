//
//  AKPersonEditViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-10.
//
//

#import "AKPersonEditViewController.h"

@interface AKPersonEditViewController ()

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
    
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:0 placeholderText:@"Username" value:@"rastin"]];
    [self addFormElement:@"name" element:[NITextInputFormElement textInputElementWithID:0 placeholderText:@"Name" value:_person.name]];
    [self addFormElement:@"email" element:[NITextInputFormElement textInputElementWithID:0 placeholderText:@"Email" value:_person.email]];
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:0 placeholderText:@"Password" value:@""]];
    [self addFormSpace];
    
    
    [self addButton:@"Save" action:^{
        [_person setValuesForKeysWithDictionary:self.formValues];
        [_person save:^{
        } failure:^(NSError *error){
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
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
