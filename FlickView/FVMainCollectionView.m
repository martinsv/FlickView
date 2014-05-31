//
//  FVMainCollectionView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVMainCollectionView.h"

@interface FVMainCollectionView()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation FVMainCollectionView

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
    //UICollectionViewFlowLayout - flowLayout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    
    //UICollectionView - mainView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.collectionView];
    
}

-(void)updateConstraints
{
    if (!self.didSetupConstraints) [self setupConstraints];
    [super updateConstraints];
}

- (void)setupConstraints
{
    //UICollectionView - mainView constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]]; //Top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]; //Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]]; //Leading constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]]; //Trailing constraint
    
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
