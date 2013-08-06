//
//  AKLoginController.m
//  AnahitaKit
//
//  Created by Arash  Sanieyan on 2012-10-31.
//  Copyright (c) 2012 Peerglobe Technology. All rights reserved.
//

#import "RestKit.h"
#import "AKTwitterReverseOAuth.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NITableViewModel+Private.h"
#import <QuartzCore/QuartzCore.h>

/**
 @class AKSignupViewController
 
 @abstract 
 Extends the AKPersonFormViewController to change some of the labels
 */
@interface AKSignupViewController : AKPersonFormViewController

@end

@implementation AKSignupViewController
{
    
}
- (void)configureTableView
{
    [super configureTableView];
    NITableViewModelSection* section = (NITableViewModelSection*)[_tableViewModel.sections objectAtIndex:0];
    section.headerTitle = NSLocalizedString(@"Register", nil);
    
    id row = [_tableViewModel objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [row setTitle:@"Sign up"];

}

@end

/**
 AKUILoginController Confirms to the {@link NITableViewModelDelegate} and {@link UITableViewDelegate} protocols
 */
@interface AKLoginViewController() <NITableViewModelDelegate,
        UITableViewDelegate, RKObjectLoaderDelegate, AKPersonFormViewControllerDelegate,
        AKSessionObjectDelegate,
        AKTwitterReverseOAuthDelegate>

- (void)showErrorAlertWithMessage:(NSString*)message;

- (void)configureTableModel;

- (BOOL)actionSignup;
- (BOOL)actionLogin;
- (BOOL)actionLoginWithTwitter;
- (BOOL)actionLoginWithFacebook;

/**
 Returns the login controller table view model. 
 */
- (NITableViewModel*)model;

@end

/**
 Text input IDs
 */
enum {
    kUsernameField = 100,
    kPasswordField = 101,
};

@implementation AKLoginViewController
{
    //table view model
    NITableViewModel* _model;
    
    NITableViewActions *_tableActions;
    
    //the controller view
    UITableView *_tableView;
    
    AKTwitterReverseOAuth *_reverseAuthentication;
    
    //Session object
    AKSessionObject *_sessionObject;
    
    /**
     The authenticated tokens
     */
    AKOAuthToken *_facebookToken, *_twitterToken;
    
}

- (id)init
{
    if ( self = [super init] ) {
        
        //set default values
        
        //by default we can register
        self.canRegister = YES;
        
        _sessionObject   = [AKSessionObject new];
        _sessionObject.delegate = self;
        
        self.facebookConsumer = [AKGlobalConfiguration.sharedInstance oAuthConsumerForService:@"facebook"];
        self.twitterConsumer  = [AKGlobalConfiguration.sharedInstance oAuthConsumerForService:@"twitter"];
        
    }
    
    return self;
}

/**
 Load view replaced the original view with a table view
 */
- (void)loadView
{
    [super loadView];
    
    //lets logout first
    [_sessionObject delete:nil onFailure:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];

    [self configureTableModel];
    
    _tableView.backgroundView  = [[UIView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundView.backgroundColor = HEXCOLOR(0xf1f1f1);
    
    if ( _headerImage ) {
        _headerView = [[UIImageView alloc] initWithImage:_headerImage];
    }
    
    _tableView.tableHeaderView = _headerView;
    
    self.view = _tableView;
}

- (void)configureTableModel
{
    _tableActions         = [[NITableViewActions alloc] initWithTarget:self];
    
    NSMutableArray* tableContents =
    [NSMutableArray arrayWithObjects:
     NSLocalizedString(@"Login", nil),
     [NITextInputFormElement textInputElementWithID:kUsernameField placeholderText:
      NSLocalizedString(@"Username",nil) value:nil],
     [NITextInputFormElement passwordInputElementWithID:kPasswordField placeholderText:
      NSLocalizedString(@"Password", nil) value:nil],
     @"",
     nil];
    
    id object;
    object = [_tableActions attachToObject:[AKButtonCellObject objectWithTitle:
                                            NSLocalizedString(@"Login",nil)] tapSelector:@selector(actionLogin)];
    
    [tableContents addObject:object];
    
    [tableContents addObject:@""];
    
    BOOL canShowConnectButton = _twitterToken == NULL && _facebookToken == NULL;
    
    //if using twitter to login
    if ( nil != self.twitterConsumer && canShowConnectButton  ) {
        object = [AKButtonCellObject objectWithTitle:@"Twitter Login" image:kAKTwitterButtonIcon];        
        object = [_tableActions attachToObject:object tapSelector:@selector(actionLoginWithTwitter)];
        [tableContents addObject:object];
    }
    
    //if using twitter to login
    if ( nil != self.facebookConsumer && canShowConnectButton ) {
        
        object = [AKButtonCellObject objectWithTitle:@"Facebook Login" image:kAKFacebookButtonIcon];
        object = [_tableActions attachToObject:object tapSelector:@selector(actionLoginWithFacebook)];
        [tableContents addObject:object];
    }
    
    if ( !canShowConnectButton ) {
        if ( _twitterToken ) {
            [tableContents addObject:@"Please login or signup so we can link your Twitter account."];
        }
        else if ( _facebookToken ) {
            [tableContents addObject:@"Please login or signup so we can link your Facebook account."];        
        }
    }
    

    
    if ( self.canRegister ) {
        
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithTitle:@"Sign up" style:UIBarButtonItemStylePlain target:self action:@selector(actionSignup)];
        
    }
    

    _model = [[NITableViewModel alloc] initWithSectionedArray:tableContents
                                                     delegate:self];
    
    _tableView.delegate   = _tableActions;
    _tableView.dataSource = _model;    
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

#pragma mark -
#pragma mark Actions

- (BOOL)actionSignup
{
    AKSignupViewController *controller = [AKSignupViewController new];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    return YES;    
}

- (BOOL)actionLogin
{
    //loging with twitter
    
    id username = [(NITextInputFormElement*)[_model elementWithID:kUsernameField] value];
    id password = [(NITextInputFormElement*)[_model elementWithID:kPasswordField] value];
    if ( username && password ) {
        [_sessionObject setUsername:username password:password];
        [_sessionObject login];
    }
    return YES;
}

- (BOOL)actionLoginWithTwitter
{    
    NSAssert(self.twitterConsumer, @"twitter consumer is null");
    
    _reverseAuthentication = [[AKTwitterReverseOAuth alloc] initWithConsumer:self.twitterConsumer];

    _reverseAuthentication.delegate = self;
    [_reverseAuthentication reverseAuthenticate];
    return YES;
}

- (BOOL)actionLoginWithFacebook
{
    NSAssert(self.twitterConsumer, @"facebook consumer is null");
    
    AKOAuthConsumer *consumer = self.facebookConsumer;
    
    FBSession *session = [[FBSession alloc] initWithAppID:consumer.key permissions:nil urlSchemeSuffix:nil tokenCacheStrategy:nil];
    [FBSession setActiveSession:session];
    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        _facebookToken = [[AKOAuthToken alloc] initWithKey:session.accessToken secret:@""];        
        [_sessionObject setOAuthToken:_facebookToken.key OAuthSecret:_facebookToken.secret OAuthService:@"facebook"];
        [_sessionObject login];
    }];
    return YES;
}

#pragma mark - 
#pragma mark AKTwitterReverseOAuthDelegate

- (void)twitterReverseOAuth:(AKTwitterReverseOAuth *)reverseOAuth didFailWithError:(int)error
{
    
}

- (void)twitterReverseOAuth:(AKTwitterReverseOAuth *)reverseOAuth didSucceedWithToken:(NSString *)token secret:(NSString *)secret info:(NSDictionary *)info
{
    NIDPRINT(@"Twitter reverse auth succesful");
    //succesfull
    //lets try to login, if loggin succesful then everything good to go
    //if not then we need to register and link the account
    _twitterToken = [[AKOAuthToken alloc] initWithKey:token secret:secret];
    [_sessionObject setOAuthToken:_twitterToken.key OAuthSecret:_twitterToken.secret OAuthService:@"twitter"];
    [_sessionObject login];
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
#pragma mark AKPersonFormViewControllerDelegate

- (void)personFormViewController:(AKPersonFormViewController *)personFormViewController willSavePerson:(AKPersonObject *)person
{
    //add the oauth token and oatuh secret
    if ( nil != _twitterToken ) {
        [person setValuesForKeysWithDictionary:@{
            @"oauth_token"   : _twitterToken.key,
            @"oauth_secret"  : _twitterToken.secret,
            @"oauth_handler" : @"twitter"
         }];
    }
    else if ( nil != _facebookToken ) {
        [person setValuesForKeysWithDictionary:@{
         @"oauth_token"   : _facebookToken.key,
         @"oauth_secret"  : _facebookToken.secret,
         @"oauth_handler" : @"facebook"
         }];
    }
}

- (void)personFormViewController:(AKPersonFormViewController *)personFormViewController didSavePerson:(AKPersonObject *)person
{
    AKSessionObject *object = [AKSessionObject sessionWithUsername:person.username password:person.password];
    object.delegate = self;
    [object login];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark AKSessionObjectDelegate

- (void)sessionObject:(AKSessionObject *)sessionObject didAuthenticatePerson:(AKPersonObject *)person
{
    //login okay lets get the viewer
    if ( self.delegate && [self.delegate respondsToSelector:@selector(loginController:didLoginPerson:)]) {
        [self.delegate loginController:self didLoginPerson:person];
    }
}

- (void)sessionObject:(AKSessionObject *)sessionObject didFailAuthenticationWithError:(AKSessionAuthenticationError)error
{
    if ( NULL == _twitterToken &&  NULL == _facebookToken )
        [self showErrorAlertWithMessage:@"Invalid username or password. Please enter your username and password"];
    else {
        if ( _twitterToken )
            [self showErrorAlertWithMessage:@"Your Twitter account is not linked. Either login with your username/password or create a new account to link your account"];
        
        else if ( _facebookToken )
            [self showErrorAlertWithMessage:@"Your Facebook account is not linked. Either login with your username/password or create a new account to link your account"];
        [self configureTableModel];
        [_tableView reloadData];
        if ( [self canRegister] ) {
            [self actionSignup];
        }
    }
}

@end