//
//  FVStylesForSideMenuView.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVStylesForSideMenuView : NSObject

#pragma mark - Global for Class

//UIViewController - CTMainSideMenuView
extern CGFloat kSideMenuItemLeadingPadding;
extern CGFloat kSideMenuItemInterPadding;
extern CGFloat kSideMenuItemContentFillPercentage; // Cell content fill percentage, height.

#pragma mark - CTMainSideMenuView

//UILabel - logoutButtonTextLabel
extern NSString *const kLogoutButtonTextLabel;

//UIImageView - logoutButtonImageView
+ (UIImage *)logoutButtonImage;

//UILabel - logoLabel
+ (UIFont *)logoLabelFont;
+ (UIColor *)logoLabelTextColor;

//UIView - contentView
+ (UIColor *)contentViewBackgroundColor;

//UITableView - tableView
extern CGFloat const kSideMenuTableViewHeightInsetPercent;
extern CGFloat const kSideMenuTableViewRowHeight; // Row height
+ (UIColor *)tableViewBackgroundColor;

#pragma mark - CTSideMenuCell

//UITableViewCell - cell
+ (UIColor *)cellBackgroundColor;

//UILabel - titleLabel
+ (UIColor *)titleLabelBacgroundColor;
+ (UIColor *)titleLabelTextColor;
+ (UIFont *)titleLabelFont;


@end
