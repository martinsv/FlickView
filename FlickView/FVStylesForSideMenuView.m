//
//  FVStylesForSideMenuView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVStylesForSideMenuView.h"

@implementation FVStylesForSideMenuView

#pragma mark - Global for Class

//UIViewController - CTMainSideMenuView
CGFloat kSideMenuItemLeadingPadding = 20; //Leading padding
CGFloat kSideMenuItemInterPadding = 10; // InterItem padding
CGFloat kSideMenuItemContentFillPercentage = 60; //%, height

#pragma mark - CTMainSideMenuView

//UILabel - logoutButtonTextLabel
NSString *const kLogoutButtonTextLabel = @"Logout";

//UIImageView - logoutButtonImageView
+ (UIImage *)logoutButtonImage {return [UIImage imageNamed:@"exitIcon"];}

//UILabel - logoLabel
+ (UIFont *)logoLabelFont {return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];}
+ (UIColor *)logoLabelTextColor {return [UIColor colorWithWhite:1.0 alpha:0.2];}

//UIView - contentView
+ (UIColor *)contentViewBackgroundColor {return [UIColor colorWithWhite:0.1 alpha:1.0];}

//UITableView - tableView
CGFloat const kSideMenuTableViewHeightInsetPercent = 20; // %
CGFloat const kSideMenuTableViewRowHeight = 70; //Row height
+ (UIColor *)tableViewBackgroundColor {return [UIColor clearColor];}

#pragma mark - CTSideMenuCell

//UITableViewCell - cell
+ (UIColor *)cellBackgroundColor {return [UIColor clearColor];}

#pragma mark - CTSideMenuCell & CTMainSideMenuView

//UILabel - titleLabel, logoutButtonTextLabel
+ (UIColor *)titleLabelBacgroundColor {return [UIColor clearColor];}
+ (UIColor *)titleLabelTextColor {return [UIColor whiteColor];}
+ (UIFont *)titleLabelFont {return [UIFont fontWithName:@"HelveticaNeue-Light" size:kSideMenuItemContentFillPercentage/4.28];}


@end
