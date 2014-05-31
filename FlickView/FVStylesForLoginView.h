//
//  FVStylesForLoginView.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVStylesForLoginView : NSObject

#pragma mark - CTLoginViewController;

//UIAlertView - alertview
extern NSString *const kAlertViewTitle;
extern NSString *const kAlertViewDescription;
extern NSString *const kAlertViewCancelButton;
extern NSString *const kAlertViewDemoButton;

#pragma mark - CTMainLoginView

//UIInterpolatingMotionEffect
extern CGFloat const kInterpolatingMotionEffectOffset;

//UIImageView - backgroundView
+ (UIImage *)backgroundImage;

//UILabel - titleLabel
+ (UIFont *)titleLabelFont;
+ (UIColor *)titleLabelTextColor;
+ (UIColor *)titleLabelBackgroundColor;

//UITextField - loginField
extern NSString *const kLoginFieldPlaceholder;
extern CGFloat const kLoginFieldBorderWidth;
extern CGFloat const kLoginFieldCornerRadius;
extern CGFloat const kLoginFieldPadding;
+ (UIFont *)loginFieldFont;
+ (UIColor *)loginFieldPlaceholderColor;
+ (UIColor *)loginFieldTextColor;
+ (UIColor *)loginFieldBackgroundColor;
+ (UIColor *)loginFieldBorderColor;
+ (UIColor *)loginFieldTintColor;

//UIButton - loginButton
+ (UIImage *)loginButtonImage;

@end
