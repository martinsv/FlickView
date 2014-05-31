//
//  FVLoginViewController.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVLoginViewController.h"
#import "FVAppDelegate.h"
#import "FVMainLoginView.h"
#import "FVViewAnimations.h"
#import "FVCredentials.h"
#import "FVFlickrDataDownloader.h"

@interface FVLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) FVMainLoginView *mainView;

@end

@implementation FVLoginViewController

//Lazy load
-(FVMainLoginView *)mainView
{
    if (!_mainView) _mainView = [[FVMainLoginView alloc] init];
    return _mainView;
}
//

-(void)loadView
{
    //Setup root view
    self.view = self.mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setup viewController
    [self setupVC];
    //Add InterpolatingMotionEffect to backgroundImage
    [self addInterpolatingMotionEffectToView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"FVLoginViewController received memory warning");
}

#pragma mark - Actions

-(void)getUserIDByName:(UIButton *)sender
{
    //Check loginField
    if ([self.mainView.loginField.text length] == 0) {
        [self handleErrorMessage];
        return;
    }
    
    //Start animations
    [self hideViewsAndStartActivity:kViewAnimationStart];
    
    //Get API key from KeyChain
    NSDictionary *credentials = [[FVCredentials sharedCredentials] getCredentials];
    
    //Query for user ID by username
    [FVFlickrDataDownloader findUserByUsername:self.mainView.loginField.text forAPIKey:credentials[kAPIKey] completion:^(NSString *userID, NSString *userName, NSError *error) {
        //Dispatch to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //Done
                [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kFlickrUserID];
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kFlickrUserName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self hideViewsAndStartActivity:kViewAnimationStop];
                [self.delegate userLoginComplete]; //Call delegate method
            } else {
                //Error
                [self handleErrorMessage];
            }
        });
    }];
}


#pragma mark - Helper Methods

- (void)setupVC
{
    //LoginField delegate
    self.mainView.loginField.delegate = self;
    
    //CTLoginViewController protocol delegate
    FVAppDelegate *appDelegate = (FVAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = (id)appDelegate.photosViewController;
    
    //Listen to changes in keyboard state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
    
    //Add target to login button
    [self.mainView.loginButton addTarget:self action:@selector(getUserIDByName:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addInterpolatingMotionEffectToView
{
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(-kInterpolatingMotionEffectOffset);
    xAxis.maximumRelativeValue = @(kInterpolatingMotionEffectOffset);
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-kInterpolatingMotionEffectOffset);
    xAxis.maximumRelativeValue = @(kInterpolatingMotionEffectOffset);
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    //Add to loginVC backgroundImage
    [self.mainView.backgroundView addMotionEffect:group];
}

- (void)hideViewsAndStartActivity:(NSString *)state
{
    if ([state isEqual:kViewAnimationStart]) {
        //Hide unwanted elements and start activityIndicator
        [FVViewAnimations fadeInOutElements:@[self.mainView.loginField, self.mainView.loginButton] forAction:kViewAnimationStart];
        //Dispath after for animations to complete, visually.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![self.mainView.activityIndicator isAnimating])[self.mainView.activityIndicator startAnimating];
        });
    } else if ([state isEqual:kViewAnimationStop]) {
        //Reverse process
        if ([self.mainView.activityIndicator isAnimating])[self.mainView.activityIndicator stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [FVViewAnimations fadeInOutElements:@[self.mainView.loginField, self.mainView.loginButton] forAction:kViewAnimationStop];
        });
    }
    
}
- (void)handleErrorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertViewTitle message:kAlertViewDescription delegate:self cancelButtonTitle:kAlertViewCancelButton otherButtonTitles:kAlertViewDemoButton, nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)keyboardWillShow:(NSNotification *)info
{
    [FVViewAnimations moveTargetView:self.mainView.subviewContainer forAction:kViewAnimationStart hideUnhideElements:@[self.mainView.loginButton] withUserInfo:info];
}

- (void)keyboardWillHide:(NSNotification *)info
{
    [FVViewAnimations moveTargetView:self.mainView.subviewContainer forAction:kViewAnimationStop hideUnhideElements:@[self.mainView.loginButton] withUserInfo:info];
}

#pragma mark - Delegates

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        //User ID query failed
        if (buttonIndex == 0) {
            //Thanks - Button pressed
        } else if (buttonIndex == 1) {
            //Demo - Button pressed
            self.mainView.loginField.text = kDefaultFlickrUser;
        }
        [self hideViewsAndStartActivity:kViewAnimationStop];
    }
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
