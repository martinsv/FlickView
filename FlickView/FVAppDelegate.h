//
//  FVAppDelegate.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVSideMenuViewController.h"
#import "FVPhotosViewController.h"
#import <MMDrawerController.h>

@interface FVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//UINavigationControllers
@property (nonatomic) UINavigationController *photosNavigationController;
@property (nonatomic) UINavigationController *albumsNavigationController;

//UIViewControllers
@property (nonatomic) FVSideMenuViewController *sideMenuViewController;
@property (nonatomic) FVPhotosViewController *photosViewController;

//MMDrawerControler
@property (nonatomic) MMDrawerController *sideMenuDrawer;

@end
