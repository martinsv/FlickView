//
//  FVStylesForPhotoView.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVStylesForPhotoView : NSObject

#pragma mark - CTMainCollectionView

//UICollectionView - collectionView
extern int const kPhotoCollectionViewNumberOfItemsInPortrait;
extern int const kPhotoCollectionViewNumberOfItemsInLandscape;
extern CGFloat const kPhotoCollectionViewInterItemSpacing;

#pragma mark - CTPhotoCell

//UICollectionViewCell - cell
extern CGFloat const kPhotoCellContentViewCornerRadius;

//UIView - contentView
+ (UIColor *)cellBackgroundColor;

@end
