//
//  FVMainLoginView.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVStylesForLoginView.h"

@interface FVMainLoginView : UIView

@property (nonatomic) UIView *subviewContainer; //Contains all elements that can be animated
@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UITextField *loginField;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end
