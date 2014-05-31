//
//  FVPhotoCell.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVPhotoCell.h"

@interface FVPhotoCell()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation FVPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
        self.backgroundColor = [FVStylesForPhotoView cellBackgroundColor];
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
    //UIView - contetView;
    self.contentView.layer.cornerRadius = kPhotoCellContentViewCornerRadius;
    self.contentView.layer.masksToBounds = YES;
    
    //UIImageView - imageView
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.imageView];
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

- (void)setupConstraints
{
    //UIImage - imageView constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
    //Finish adding constraints
    self.didSetupConstraints = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.photo = nil;
    self.image = nil;
    self.imageView.image = nil;
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
    self.image = self.photo.thumbImage;
    [self displayPhoto];
}

- (void)displayPhoto
{
    self.imageView.image = self.image;
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
