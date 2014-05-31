//
//  FVFooterView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVFooterView.h"

@interface FVFooterView()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation FVFooterView

-(id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
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
    //UILabel - doneLoadingLabel
    self.doneLoadingLabel = [[UILabel alloc] init];
    self.doneLoadingLabel.hidden = YES;
    self.doneLoadingLabel.text = @"Everything is loaded";
    self.doneLoadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    self.doneLoadingLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.doneLoadingLabel.textAlignment = NSTextAlignmentCenter;
    self.doneLoadingLabel.numberOfLines = 1;
    self.doneLoadingLabel.adjustsFontSizeToFitWidth = YES;
    self.doneLoadingLabel.backgroundColor = [UIColor clearColor];
    [self.doneLoadingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.doneLoadingLabel];
    
    //UIActivityIndicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.activityIndicator];
    
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

- (void)setupConstraints
{
    //UIActivityIndicator constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UILabel - doneLoadingLabel constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneLoadingLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneLoadingLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneLoadingLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneLoadingLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
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
