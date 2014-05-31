//
//  FVStylesForLoginView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVStylesForLoginView.h"

@implementation FVStylesForLoginView

#pragma mark - CTLoginViewController;

//UIAlertView - alertview
NSString *const kAlertViewTitle = @"Sorry!";
NSString *const kAlertViewDescription = @"User with this name doesn't exist";
NSString *const kAlertViewCancelButton = @"Ok";
NSString *const kAlertViewDemoButton = @"Demo";

#pragma mark - CTMainLoginView

//UIInterpolatingMotionEffect
CGFloat const kInterpolatingMotionEffectOffset = 20; // parralax ammount

//UIImageView - backgroundView
+ (UIImage *)backgroundImage {return [UIImage imageNamed:@"mainImage"];}

//UILabel - titleLabel
+ (UIFont *)titleLabelFont {return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60.0];}
+ (UIColor *)titleLabelTextColor {return [UIColor blackColor];}
+ (UIColor *)titleLabelBackgroundColor {return [UIColor clearColor];}

//UITextField - loginField
NSString *const kLoginFieldPlaceholder = @"Enter Flickr User";
CGFloat const kLoginFieldBorderWidth = 1.0;
CGFloat const kLoginFieldCornerRadius = 12.0;
CGFloat const kLoginFieldPadding = 10;
+ (UIFont *)loginFieldFont {return [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];}
+ (UIColor *)loginFieldPlaceholderColor {return [UIColor darkGrayColor];}
+ (UIColor *)loginFieldTextColor {return [UIColor blackColor];}
+ (UIColor *)loginFieldBackgroundColor {return [UIColor clearColor];}
+ (UIColor *)loginFieldBorderColor {return [UIColor blackColor];}
+ (UIColor *)loginFieldTintColor {return [UIColor blackColor];}

//UIButton - loginButton
+ (UIImage *)loginButtonImage {return [UIImage imageNamed:@"loginButton"];}

@end
