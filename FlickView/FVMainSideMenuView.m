//
//  FVMainSideMenuView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVMainSideMenuView.h"
#import "FVViewAnimations.h"

@interface FVMainSideMenuView()

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) UIImageView *logoutButtonImageView;
@property (nonatomic) UILabel *logoutButtonTextLabel, *logoLabel;

@end

@implementation FVMainSideMenuView

-(id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [FVStylesForSideMenuView contentViewBackgroundColor];
        self.didSetupConstraints = NO;
        [self addSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Views

- (void)addSubviews
{
    //UITableView - tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [FVStylesForSideMenuView tableViewBackgroundColor];
    self.tableView.bounces = YES;
    self.tableView.rowHeight = kSideMenuTableViewRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.tableView];
    
    //UILabel - logoLabel
    self.logoLabel = [[UILabel alloc] init];
    self.logoLabel.text = kApplicationName;
    self.logoLabel.font = [FVStylesForSideMenuView logoLabelFont];
    self.logoLabel.textColor = [FVStylesForSideMenuView logoLabelTextColor];
    self.logoLabel.numberOfLines = 1;
    self.logoLabel.textAlignment = NSTextAlignmentLeft;
    self.logoLabel.backgroundColor = [UIColor clearColor];
    [self.logoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.logoLabel];
    
    //UIButton - logoutButton
    self.logoutButton = [[UIButton alloc] init];
    self.logoutButton.backgroundColor = [UIColor clearColor];
    self.logoutButton.clipsToBounds = YES;
    [self.logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.logoutButton];
    
    //UIImageView - logoutButtonImageView
    self.logoutButtonImageView = [[UIImageView alloc] init];
    self.logoutButtonImageView.image = [FVStylesForSideMenuView logoutButtonImage];
    self.logoutButtonImageView.backgroundColor = [UIColor clearColor];
    self.logoutButtonImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoutButtonImageView.clipsToBounds = YES;
    [self.logoutButtonImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.logoutButton addSubview:self.logoutButtonImageView];
    
    //UILabel - logoutButtonTextLabel
    self.logoutButtonTextLabel = [[UILabel alloc] init];
    self.logoutButtonTextLabel.text = kLogoutButtonTextLabel;
    self.logoutButtonTextLabel.font = [FVStylesForSideMenuView titleLabelFont];
    self.logoutButtonTextLabel.textColor = [FVStylesForSideMenuView titleLabelTextColor];
    self.logoutButtonTextLabel.textAlignment = NSTextAlignmentLeft;
    self.logoutButtonTextLabel.numberOfLines = 1;
    self.logoutButtonTextLabel.adjustsFontSizeToFitWidth = YES;
    self.logoutButtonTextLabel.backgroundColor = [FVStylesForSideMenuView titleLabelBacgroundColor];
    [self.logoutButtonTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.logoutButton addSubview:self.logoutButtonTextLabel];
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)) {
        //Portrait Orientation
        [FVViewAnimations fadeInOutElements:@[self.logoLabel] forAction:kViewAnimationStop];
    }
    else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft|| ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)){
        //Landscape Orientation
        [FVViewAnimations fadeInOutElements:@[self.logoLabel] forAction:kViewAnimationStart];
    }
}

- (void)setupConstraints
{
    //Calculate content offset from content fill percentage
    CGFloat contentFillOffset = (kSideMenuTableViewRowHeight * ((100 - kSideMenuItemContentFillPercentage)/100)) /2;
    //UILabel - logoLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:kSideMenuItemLeadingPadding]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UItableView - tableView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UIButton - logoutButton
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kSideMenuTableViewRowHeight]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UIImageView - logoutButtonImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentFillOffset]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-contentFillOffset]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:kSideMenuItemLeadingPadding]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.logoutButtonImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]]; //Width constraint
    
    //UILabel - logoutButtonTextLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentFillOffset]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonTextLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-contentFillOffset]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonTextLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.logoutButtonImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:kSideMenuItemInterPadding]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoutButtonTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.logoutButton attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
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
