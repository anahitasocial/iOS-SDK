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
    __weak__(self);
    [[self addButton:NSLocalizedString(@"LOGIN-BUTTON", @"Login") action:^{
        NSDictionary *params = [weakself formValues];
        [[AKSession sessionWithCredential:params] login:nil failure:^(NSError *error) {
            AKAlertViewShow(
                NSLocalizedString(@"LOGIN-FAILED", @"Login Failed"),
                NSLocalizedString(@"LOGIN-FAILED-BAD-USERBANE", @"Invalid username or passowrd\nPlease try again"),
                nil
            );
        }];
    }]
    addStyleTag:@"LoginButton"];
    [self addFormSpace];
    if ( FBSession.activeSession != nil )
    {
        [[self addButton:NSLocalizedString(@"FB-LOGIN-BUTTON", @"Login with Facebook") action:^{
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if ( status & FBSessionStateOpen )
                {
                    AKOAuthSessionCredential *credential = [AKOAuthSessionCredential
                        credentialWithToken:session.accessTokenData.accessToken
                        secret:nil
                        serivce:kAKFacebookServiceType];
                    
                    [[AKSession sessionWithCredential:credential] login:nil failure:^(NSError *error) {
                        //need to signup so set the viewer credential
                         [AKSession.sharedSession.viewer setOAuthToken:credential];
                         NIDPRINT(@"FB Auth passed. No user account need to create Anahita account");
                    }];
                }
                
            }];
        }]
        addStyleTag:@"FacebookLoginButton"];
        ;
    }
    
    if ( [AKServiceConfiguration sharedConiguration].twitterConsumer != nil )
    {
        [[self addButton:NSLocalizedString(@"TW-LOGIN-BUTTON", @"Login with Twitter") action:^{
            [SHOmniAuthTwitter performLoginWithListOfAccounts:^(NSArray *accounts, SHOmniAuthAccountPickerHandler pickAccountBlock) {
                    pickAccountBlock([accounts objectAtIndex:0]);
            } onComplete:^(id<account> account, id response, NSError *error, BOOL isSuccess) {

                    AKOAuthSessionCredential *credential = [AKOAuthSessionCredential credentialWithToken:[response valueForKeyPath:@"auth.credentials.token"]
                        secret:[response valueForKeyPath:@"auth.credentials.secret"]
                        serivce:kAKTwitterServiceType];

                    [[AKSession sessionWithCredential:credential] login:nil failure:^(NSError *error) {
                         //need to signup
                         [AKSession.sharedSession.viewer setOAuthToken:credential];
                         NIDPRINT(@"TW Auth passed. No user account need to create Anahita account");
                    }];
            }];
        }]
        addStyleTag:@"TwitterLoginButton"];
        ;    
    }
    
    [super viewDidLoad];
    [self.tableView addStyleTag:@"LoginTableView"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
