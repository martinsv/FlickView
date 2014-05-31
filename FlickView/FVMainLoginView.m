//
//  FVMainLoginView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVMainLoginView.h"

@interface FVMainLoginView()

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation FVMainLoginView

-(id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.didSetupConstraints = NO;
        [self addSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Views

- (void)addSubviews
{
    //UIImageView - backgroundView
    self.backgroundView = [[UIImageView alloc] initWithImage:[FVStylesForLoginView backgroundImage]];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.clipsToBounds = YES;
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.backgroundView];
    
    //UIView - subviewContainer
    self.subviewContainer = [[UIView alloc] init];
    self.subviewContainer.backgroundColor = [UIColor clearColor];
    [self.subviewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.subviewContainer];
    
    //UILabel - titleLabel
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [FVStylesForLoginView titleLabelFont];
    self.titleLabel.text = kApplicationName;
    self.titleLabel.textColor = [FVStylesForLoginView titleLabelTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [FVStylesForLoginView titleLabelBackgroundColor];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subviewContainer addSubview:self.titleLabel];
    
    //UITextField - loginField
    self.loginField = [[UITextField alloc] init];
    UIView *loginFieldPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLoginFieldPadding, 0)];
    self.loginField.leftView = loginFieldPadding;
    self.loginField.leftViewMode = UITextFieldViewModeAlways;
    self.loginField.font = [FVStylesForLoginView loginFieldFont];
    if ([self.loginField respondsToSelector:@selector(setAttributedPlaceholder:)]) self.loginField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLoginFieldPlaceholder attributes:@{NSForegroundColorAttributeName: [FVStylesForLoginView loginFieldPlaceholderColor]}];
    else self.loginField.placeholder = kLoginFieldPlaceholder; //Fall-back for deployment targets earlier than iOS 6.0
    self.loginField.text = kDefaultFlickrUser;
    self.loginField.textColor = [FVStylesForLoginView loginFieldTextColor];
    self.loginField.backgroundColor = [FVStylesForLoginView loginFieldBackgroundColor];
    self.loginField.tintColor = [FVStylesForLoginView loginFieldTintColor];
    self.loginField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.loginField.returnKeyType = UIReturnKeyDone;
    self.loginField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.loginField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginField.layer.borderWidth = kLoginFieldBorderWidth;
    self.loginField.layer.borderColor = [FVStylesForLoginView loginFieldBorderColor].CGColor;
    self.loginField.layer.cornerRadius = kLoginFieldCornerRadius;
    [self.loginField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subviewContainer addSubview:self.loginField];
    
    //UIButton - loginButton
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.backgroundColor = [UIColor clearColor];
    [self.loginButton setImage:[FVStylesForLoginView loginButtonImage] forState:UIControlStateNormal];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subviewContainer addSubview:self.loginButton];
    
    //UIActivityIndicatorView
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subviewContainer addSubview:self.activityIndicator];
    
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

- (void)setupConstraints
{
    //UIImage - backgroundView constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-kInterpolatingMotionEffectOffset]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:kInterpolatingMotionEffectOffset]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-kInterpolatingMotionEffectOffset]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:kInterpolatingMotionEffectOffset]]; //Trailing constraint
    
    //UIView - subviewContainer constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subviewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subviewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subviewContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subviewContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UILabel - titleLabel constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.loginField attribute:NSLayoutAttributeTop multiplier:1.0 constant:-30.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:25.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20.0]]; //Trailing constraint
    
    //UITextField - loginField constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10.0]]; //Center constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30.0]]; //Trailing constraint
    
    //UIButton - loginButton constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
    //Width constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    //X constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:90.0]]; //Y constraint
    
    //UIActivityIndicatorView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10.0]]; //Center constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-30.0]]; //Trailing constraint
    
    //Finish adding constraints
    self.didSetupConstraints = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
