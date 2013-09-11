//
//  AKSignupViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-10.
//
//

#import "AKSignupViewController.h"

@interface AKSignupViewController ()

@end

@implementation AKSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    int r = arc4random() % 1000;
    AKPerson *person = [AKSession sharedSession].viewer;
    person.name     = [NSString stringWithFormat:@"arash%d", r];
    person.username = [NSString stringWithFormat:@"arash%d", r];
    person.email = [NSString stringWithFormat:@"arash%d@example.com", r];
    person.password = [NSString stringWithFormat:@"arash%d@example.com", r];
    
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"USERNAME-LABEL", @"Username") value:person.username]];
    
    [self addFormElement:@"name" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"NAME-LABEL", @"Name") value:person.name]];
    
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"EMAIL-LABEL", @"Email") value:person.email]];

    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"PASSWORD-LABEL", @"Password") value:person.password]];

    [self addFormSpace];
    
    __weak__(self);
    [self addButton:NSLocalizedString(@"SIGN-UP-BUTTON", @"Sign Up") action:^{
        [person setValuesForKeysWithDictionary:weakself.formValues];
        
        //somehowe we need to get the last oauth credential
        //to pass to person::save
        
        [person save:^{
            AKSession *session = [AKSession sessionWithCredential:@{@"username":person.username, @"password":person.password}];
            [session login];
        } failure:^(NSError *error){
            NSMutableArray *msgs = [NSMutableArray array];
            if ( [error key:@"username" didFailWithCode:@"NotUnique"] ) {
                [msgs addObject:NSLocalizedString(@"NON-UNIQUE-USERNAME-ERROR", @"Please enter a unique username")];
            }
            else if ( [error key:@"email" didFailWithCode:@"NotUnique"] ) {
                [msgs addObject:NSLocalizedString(@"NON-UNIQUE-EMAIL", @"Please enter a unique email")];
            }
            AKAlertViewShow(nil, msgs, nil);
        }];
    }];
    [self.tableView addStyleTag:@"SignupTableView"];
}

- (void)signup
{
    AKPerson *person = [AKPerson new];
    [person setValuesForKeysWithDictionary:self.formValues];
    [person save:^{
        AKSession *session = [AKSession sessionWithCredential:@{@"username":person.username, @"password":person.password}];
        [session login];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
