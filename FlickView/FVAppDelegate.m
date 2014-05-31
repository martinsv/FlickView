//
//  FVAppDelegate.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVAppDelegate.h"
#import "FVCredentials.h"
#import "FVAlbumsViewController.h"
#import "FVSideMenuViewController.h"
#import <MMDrawerVisualState.h>

@implementation FVAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Init NC & VC
    self.photosViewController = [[FVPhotosViewController alloc] initWithType:kPhotosVCTypeAllPhotos];
    self.sideMenuViewController = [[FVSideMenuViewController alloc] init];
    self.photosNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photosViewController];
    self.albumsNavigationController = [[UINavigationController alloc] initWithRootViewController:[[FVAlbumsViewController alloc] init]];
    
    //Init drawerController - sideMenuDrawer
    self.sideMenuDrawer = [[MMDrawerController alloc] initWithCenterViewController:self.photosNavigationController leftDrawerViewController:self.sideMenuViewController];
    //self.sideMenuController.childViewControllerForStatusBarHidden = nil;
    [self.sideMenuDrawer setMaximumLeftDrawerWidth:kSideMenuWidth]; // Drawer width
    self.sideMenuDrawer.shouldStretchDrawer = NO;
    [self.sideMenuDrawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.sideMenuDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.sideMenuDrawer setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3.0]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Save API Key to URLCredentials/KeyChain
    [[FVCredentials sharedCredentials] setName:@"FlickView" andAPIKey:@"605ae8f89d8de4583e66ab5f0f11131d"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.sideMenuDrawer;
    [self.window makeKeyAndVisible];
    [self setAppearances];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setAppearances
{
    //setup
    //Change navigationController barStyle
    self.photosNavigationController.navigationBar.translucent = YES;
    self.photosNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.albumsNavigationController.navigationBar.translucent = YES;
    self.albumsNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //Global appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

@end
