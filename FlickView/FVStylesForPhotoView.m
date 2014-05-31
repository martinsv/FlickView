//
//  FVStylesForPhotoView.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVStylesForPhotoView.h"

@implementation FVStylesForPhotoView

#pragma mark - CTMainCollectionView

//UICollectionView - collectionView
int const kPhotoCollectionViewNumberOfItemsInPortrait = 3; //Items portrait, min. 2
int const kPhotoCollectionViewNumberOfItemsInLandscape = 6; //Items landscape, min. 2
CGFloat const kPhotoCollectionViewInterItemSpacing = 1.0; //Item spacing

#pragma mark - CTPhotoCell

//UICollectionViewCell - cell
CGFloat const kPhotoCellContentViewCornerRadius = 0;

//UIView - contentView
+(UIColor *)cellBackgroundColor {return [UIColor clearColor];}

@end
