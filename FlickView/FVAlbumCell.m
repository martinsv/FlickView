//
//  FVAlbumCell.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVAlbumCell.h"

@interface FVAlbumCell()

@property (nonatomic) BOOL didSetupConstraints;
//Constraints
@property (nonatomic) NSLayoutConstraint *titleLabelHeightConstraint;

@end

@implementation FVAlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [FVStylesForAlbumView cellBackgroundColor];
        self.didSetupConstraints = NO;
        [self addSubviews];
        [self setNeedsUpdateConstraints];
        
        //Listen to FVPhoto notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleFVPhotoThumbDidEndLoading:)
                                                     name:FVPHOTO_THUMB_DID_END_LOADING
                                                   object:nil];
    }
    return self;
}

#pragma mark - Views

- (void)addSubviews
{
    //UIView - contentView
    self.contentView.layer.cornerRadius = kAlbumCellContentViewCornerRadius;
    self.contentView.layer.masksToBounds = YES;
    
    //UIImageView - imageView
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.imageView];
    
    //UILabel - countLabel
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [FVStylesForAlbumView countLabelFont];
    self.countLabel.textColor = [FVStylesForAlbumView titleLabelTextColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.numberOfLines = 1;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.backgroundColor = [FVStylesForAlbumView countLabelBacgroundColor];
    self.countLabel.layer.cornerRadius = kAlbumCellCountLabelCornerRadius;
    self.countLabel.layer.masksToBounds = YES;
    [self.countLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.countLabel];
    
    //UILabel - titleLabel
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [FVStylesForAlbumView titleLabelFont];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.backgroundColor = [FVStylesForAlbumView titleLabelBacgroundColor];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.titleLabel];
    
}
-(void)layoutSubviews
{
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
    //Update when device rotates
    self.titleLabelHeightConstraint.constant = self.contentView.frame.size.height*(kAlbumCellTitleLabelHeightPercentage/100); //TitleView height
}

- (void)setupConstraints
{
    //UIImageView - imageView constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UILabel - titleLabel constraints
    self.titleLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.contentView.frame.size.height*(kAlbumCellTitleLabelHeightPercentage/100)]; //Height constraint
    [self addConstraint:self.titleLabelHeightConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //UILabel - countLabel constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:kAlbumCellCountLabelOffsetX]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kAlbumCellCountLabelHeight]]; //Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kAlbumCellCountLabelWidth]]; //Width constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-kAlbumCellCountLabelOffsetY]]; //Trailing constraint
    
    //Finish adding constraints
    self.didSetupConstraints = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.photo = nil;
    self.imageView.image = nil;
    self.titleLabel.text = nil;
}

#pragma mark - Helper Methods

-(void)loadPhoto
{
    //Start thumb loading
    [self.photo loadThumbImageAndNotify];
}
- (void)handleFVPhotoThumbDidEndLoading:(NSNotificationCenter *)sender
{
    //Thumb loaded - display
    [self displayPhotoAndUpdateText];
}
- (void)displayPhotoAndUpdateText
{
    self.imageView.image = self.photo.thumbImage;
    self.titleLabel.text = self.photo.photoTitle;
    self.countLabel.text = self.photo.photosetPhotoCount;
}

- (void)dealloc
{
    //Deallocate NSNotificationCenter for cell reuse
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
