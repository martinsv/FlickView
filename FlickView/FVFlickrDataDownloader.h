//
//  FVFlickrDataDownloader.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

//Flickr API request types - photostream, photoset, album etc.
extern NSString *const kFlickrAPIRequestAllPhotosKey;
extern NSString *const kFlickrAPIRequestAllPhotosetsKey;
extern NSString *const kFlickrAPIRequestAllPhotosInPhotosetKey;

@interface FVFlickrDataDownloader : NSObject

+ (void)getImageListFromFlickerForRequestType:(NSString *)requestType forAPIKey:(NSString *)apiKey forTaskID:(NSString *)taskID forPage:(int)page perPage:(int)count completion:(void(^)(NSArray *location, int currentPage, int totalPages, NSError *error))completion;

+ (void)findUserByUsername:(NSString *)username forAPIKey:(NSString *)apiKey completion:(void(^)(NSString *userID, NSString *userName, NSError *error))completion;

@end
