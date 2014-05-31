//
//  FVPhotoCell.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVStylesForPhotoView.h"
#import "FVPhotoObject.h"

@interface FVPhotoCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImage *image;
@property (nonatomic) FVPhotoObject *photo;

- (void)loadPhoto;

@end
