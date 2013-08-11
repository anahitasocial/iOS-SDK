//
//  AKLoginViewController.m
//  Pods
//
//  Created by Arash  Sanieyan on 2013-08-07.
//
//

#import "AKAnahitaUI.h"

@interface AKLoginViewController() 

@end

@implementation AKLoginViewController

- (void)viewDidLoad
{
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"USERNAME-LABEL", @"Username") value:@""]];
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"PASSWORD-LABEL", @"Password") value:@""]];
    [self addFormSpace];
    id weakSelf = self;
    [self addButton:NSLocalizedString(@"LOGIN-BUTTON", @"Login") action:^{
        NSDictionary *params = [weakSelf formValues];
        [[AKSession sessionWithCredential:params] login:nil failure:^(NSError *error) {
            AKAlertViewShow(
                NSLocalizedString(@"LOGIN-FAILED", @"Login Failed"),
                NSLocalizedString(@"LOGIN-FAILED-BAD-USERBANE", @"Invalid username or passowrd\nPlease try again"),
                nil
            );
        }];
    }];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
