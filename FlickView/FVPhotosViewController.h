//
//  FVPhotosViewController.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>

//VC type keys - initWithType
extern NSString *const kPhotosVCTypeAllPhotos;
extern NSString *const kPhotosVCTypeAllPhotosetPhotos;

@interface FVPhotosViewController : UIViewController

//Task ID - Flickr userID, photosetID, etc
@property (nonatomic) NSString *taskID;

//Init with style - photos or photosetPhotos
- (id)initWithType:(NSString *)type;

@end
