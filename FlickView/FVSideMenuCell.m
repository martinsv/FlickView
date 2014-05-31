//
//  FVSideMenuCell.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVSideMenuCell.h"
#import "FVStylesForSideMenuView.h"

@interface FVSideMenuCell()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation FVSideMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [FVStylesForSideMenuView cellBackgroundColor];
        [self addSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Views

- (void)addSubviews
{
    //UIImageView - iconImageView
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    [self.iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.iconImageView];
    
    //UILabel - titleLabel
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [FVStylesForSideMenuView titleLabelFont];
    self.titleLabel.textColor = [FVStylesForSideMenuView titleLabelTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.backgroundColor = [FVStylesForSideMenuView titleLabelBacgroundColor];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.titleLabel];
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

- (void)setupConstraints
{
    //Calculate content offset from content fill percentage
    CGFloat contentFillOffset = (kSideMenuTableViewRowHeight * ((100 - kSideMenuItemContentFillPercentage)/100)) /2;
    //UIImageView - iconImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentFillOffset]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-contentFillOffset]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:kSideMenuItemLeadingPadding]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]]; //Width constraint
    
    //UILabel - titleLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentFillOffset]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-contentFillOffset]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:kSideMenuItemInterPadding]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //Finish adding constraints
    self.didSetupConstraints = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIView *blackSelectedView = [[UIView alloc] init];
    blackSelectedView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    [super setSelected:selected animated:NO];
    
    // Configure the view for the selected state
    self.selectedBackgroundView = blackSelectedView;
}

@end
