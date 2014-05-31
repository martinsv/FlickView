//
//  FVStylesForAlbumView.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVStylesForAlbumView : NSObject

#pragma mark - UIMainCollectionView

//UICollectionView - collectionView
extern int const kAlbumCollectionViewNumberOfItemsInPortrait;
extern int const kAlbumCollectionViewNumberOfItemsInLandscape;
extern CGFloat const kAlbumCollectionViewItemSpacing;

#pragma mark - CTPhotoCell

//UICollectionViewCell - cell
+ (UIColor *)cellBackgroundColor;

//UIView - contentView
extern CGFloat const kAlbumCellContentViewCornerRadius;

//UILabel - titleLabel
extern CGFloat const kAlbumCellTitleLabelHeightPercentage;
+ (UIColor *)titleLabelBacgroundColor;
+ (UIColor *)titleLabelTextColor;
+ (UIFont *)titleLabelFont;

//UILabel - countLabel
extern float const kAlbumCellCountLabelHeight;
extern float const kAlbumCellCountLabelWidth;
extern float const kAlbumCellCountLabelOffsetX;
extern float const kAlbumCellCountLabelOffsetY;
extern CGFloat const kAlbumCellCountLabelCornerRadius;
+ (UIColor *)countLabelBacgroundColor;
+ (UIFont *)countLabelFont;

@end
