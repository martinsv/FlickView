//
//  FVStylesForAlbumView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVStylesForAlbumView.h"

@implementation FVStylesForAlbumView

#pragma mark - UIMainCollectionView

//UICollectionView - collectionView
int const kAlbumCollectionViewNumberOfItemsInPortrait = 2; //Items portrait
int const kAlbumCollectionViewNumberOfItemsInLandscape = 4; //Items landscape
CGFloat const kAlbumCollectionViewItemSpacing = 20.0; //Item spacing

#pragma mark - CTPhotoCell

//UICollectionViewCell - cell
+(UIColor *)cellBackgroundColor {return [UIColor clearColor];}

//UIView - contentView
CGFloat const kAlbumCellContentViewCornerRadius = 0.0;

//UILabel - titleLabel
CGFloat const kAlbumCellTitleLabelHeightPercentage = 25; //%
+(UIColor *)titleLabelBacgroundColor {return [UIColor colorWithWhite:0.0 alpha:0.4];}
+ (UIColor *)titleLabelTextColor {return [UIColor whiteColor];}
+(UIFont *)titleLabelFont {return [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];}

//UILabel - countLabel
float const kAlbumCellCountLabelHeight = 22.0;
float const kAlbumCellCountLabelWidth = 30.0;
float const kAlbumCellCountLabelOffsetX = 3.0;
float const kAlbumCellCountLabelOffsetY = 3.0;
CGFloat const kAlbumCellCountLabelCornerRadius = 8.0;
+(UIColor *)countLabelBacgroundColor {return [UIColor colorWithWhite:0.0 alpha:0.4];}
+(UIFont *)countLabelFont {return [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];}

@end
