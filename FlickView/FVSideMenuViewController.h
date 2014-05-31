//
//  FVSideMenuViewController.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVLoginViewController.h"

@protocol FVSideMenuViewControllerDelegate <NSObject>

@required

//This method will be called when user selects logoutButton
- (void)logoutButtonPressed;

@optional
//Notify photosVC when sideMenu willAppear
- (void)sideMenuWillAppear;

@end

@interface FVSideMenuViewController : UIViewController

@property (nonatomic, weak) id <FVSideMenuViewControllerDelegate> delegate;

@property (nonatomic) FVLoginViewController *loginVC;

@end
