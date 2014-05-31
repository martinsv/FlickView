//
//  FVAlbumCell.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVStylesForAlbumView.h"
#import "FVPhotoObject.h"

@interface FVAlbumCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLabel, *countLabel;
@property (nonatomic) FVPhotoObject *photo;

- (void)loadPhoto;

@end
