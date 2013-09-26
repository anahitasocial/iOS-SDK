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

NSString * const kAKServiceDidAuthorizeWithoutMathhingAccount = @"kAKServiceDidAuthorizeWithoutMathhingAccount";

@implementation AKLoginViewController

- (id)init
{
    if ( self = [super init] ) {
         
    }    
    return self;
}
- (void)viewDidLoad
{
    [self addFormElement:@"username" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"USERNAME-LABEL", @"Username") value:@""]];
    [self addFormElement:@"password" element:[NITextInputFormElement textInputElementWithID:0
            placeholderText:NSLocalizedString(@"PASSWORD-LABEL", @"Password") value:@""]];
    [self addFormSpace];
    __weak__(self);
    [[self addButton:NSLocalizedString(@"LOGIN-BUTTON", @"Login") action:^{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:weakself.formValues];
        if ( FBSession.activeSession.state == FBSessionStateOpen )
        {
                    AKOAuthSessionCredential *credential = [AKOAuthSessionCredential
                        credentialWithToken:FBSession.activeSession.accessTokenData.accessToken
                        secret:nil
                        serivce:kAKFacebookServiceType];
                    [params addEntriesFromDictionary:[credential toParameters]];
        }
                
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
    
    [[self addButton:NSLocalizedString(@"FB-LOGIN-BUTTON", @"Login with Facebook") action:^{
        //if facebook session is not already open then open a new one
        if (
            FBSession.activeSession.state == FBSessionStateOpen
            ) {
            [[FBSession activeSession] close];
        }
            
        if ( FBSession.activeSession.state == FBSessionStateCreated ||
            FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ||
            FBSession.activeSession.state == FBSessionStateClosed
        )
        {
            FBSessionStateHandler handler = ^(FBSession *session,
                                       FBSessionState status,
                                       NSError *error)
            {
               if ( status == FBSessionStateOpen )
               {
               
                    AKOAuthSessionCredential *credential = [AKOAuthSessionCredential
                        credentialWithToken:session.accessTokenData.accessToken
                        secret:nil
                        serivce:kAKFacebookServiceType];
                    
                    [[AKSession sessionWithCredential:credential] login:nil failure:^(NSError *error) {
                        //need to signup so set the viewer credential
                         [AKSession.sharedSession.viewer setOAuthToken:credential];
                         NIDPRINT(@"FB Authorized. Can't find a user to match");
                         NIDPRINT(@"Storing the credential in the viewer %@ %@", AKSession.sharedSession.viewer, [credential toParameters]);
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAKServiceDidAuthorizeWithoutMathhingAccount object:credential userInfo:nil];                        
                    }];
                }            
            };
            
            FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:@[] defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
            [session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:handler];
            [FBSession setActiveSession:session];            
            
        }        
    }]
    addStyleTag:@"FacebookLoginButton"];
    ;
    
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
                         NIDPRINT(@"Twitter Authorized. Can't find a user to match");
                         NIDPRINT(@"Storing the credential in the viewer %@ %@", AKSession.sharedSession.viewer, [credential toParameters]);
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAKServiceDidAuthorizeWithoutMathhingAccount object:credential userInfo:nil];
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
