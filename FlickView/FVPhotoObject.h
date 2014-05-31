//
//  FVPhotoObject.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhotoProtocol.h>

//CollectionViewCell Image Notification
#define FVPHOTO_THUMB_DID_END_LOADING @"FVPHOTO_THUMB_DID_END_LOADING"

//Thumb photo keys - initWithStyle
extern NSString *const kFlickrThumbStylePhoto;
extern NSString *const kFlickrThumbStylePhotoset;

@interface FVPhotoObject : NSObject <MWPhoto>

@property (nonatomic) NSURL *thumbImageURL, *largeImageURL;
@property (nonatomic) UIImage *thumbImage, *largeImage;

//Flickr API Keys
@property (nonatomic) NSString *photoID, *photosetID, *photosetPhotoCount, *photoFarm, *photoServer, *photoSecret, *photoTitle;

//Methods
- (id)initWithData:(NSDictionary *)data andStyle:(NSString *)style;

- (void)loadThumbImageAndNotify;

@end
