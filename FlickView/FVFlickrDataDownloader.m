//
//  FVFlickrDataDownloader.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVFlickrDataDownloader.h"

//Flickr API request types - photostream, photoset, album etc.
NSString *const kFlickrAPIRequestAllPhotosKey           = @"flickr.people.getPublicPhotos";
NSString *const kFlickrAPIRequestAllPhotosetsKey        = @"flickr.photosets.getList";
NSString *const kFlickrAPIRequestAllPhotosInPhotosetKey = @"flickr.photosets.getPhotos";

//Flickr API request and response keys
static NSString *const kFlickrAPIOKStatusCodeKey        = @"ok";
static NSString *const kFlickrAPITaskTypeUserKey        = @"user_id=";
static NSString *const kFlickrAPITaskTypePhotosetKey    = @"photoset_id=";

@implementation FVFlickrDataDownloader

+ (void)getImageListFromFlickerForRequestType:(NSString *)requestType forAPIKey:(NSString *)apiKey forTaskID:(NSString *)taskID forPage:(int)page perPage:(int)count completion:(void(^)(NSArray *location, int currentPage, int totalPages, NSError *error))completion
{
    //Check if arguments are present
    if (apiKey == nil || taskID == nil || requestType == nil || count == 0) {
        NSArray *location = nil;
        int currentPage = 0;
        int totalPages = 0;
        NSError *error = [[NSError alloc] init];
        completion(location, currentPage, totalPages, error);
        return;
    }
    //Check for task type
    NSString *taskType = kFlickrAPITaskTypeUserKey;
    if ([requestType isEqual:kFlickrAPIRequestAllPhotosInPhotosetKey]) taskType = kFlickrAPITaskTypePhotosetKey;
    
    //Download JSON data form Flickr
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=%@&api_key=%@&format=json&nojsoncallback=1&%@%@&page=%i&per_page=%i&", requestType, apiKey, taskType, taskID, page, count];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSArray *imageArray = nil;
        int currentPage = 0;
        int totalPages = 0;
        
        if (!error) {
            //Download task was successful
            NSData *data = [NSData dataWithContentsOfURL:location];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            //Check server status code
            NSString *statusCode = [responseDictionary valueForKey:@"stat"];
            if ([statusCode isEqual:kFlickrAPIOKStatusCodeKey]) {
                //Load data
                if ([requestType isEqual:kFlickrAPIRequestAllPhotosKey]) {
                    //All photos
                    imageArray = [responseDictionary valueForKeyPath:@"photos.photo"];
                    currentPage = [[responseDictionary valueForKeyPath:@"photos.page"] intValue];
                    totalPages = [[responseDictionary valueForKeyPath:@"photos.pages"] intValue];
                } else if ([requestType isEqual:kFlickrAPIRequestAllPhotosetsKey]) {
                    //All photosets
                    imageArray = [responseDictionary valueForKeyPath:@"photosets.photoset"];
                    currentPage = [[responseDictionary valueForKeyPath:@"photosets.page"] intValue];
                    totalPages = [[responseDictionary valueForKeyPath:@"photosets.pages"] intValue];
                } else if ([requestType isEqual:kFlickrAPIRequestAllPhotosInPhotosetKey]) {
                    //All photos in photoset
                    imageArray = [responseDictionary valueForKeyPath:@"photoset.photo"];
                    currentPage = [[responseDictionary valueForKeyPath:@"photoset.page"] intValue];
                    totalPages = [[responseDictionary valueForKeyPath:@"photoset.pages"] intValue];
                }
                
            } else error = [[NSError alloc] init];
        }
        completion(imageArray, currentPage, totalPages, error);
    }];
    [downloadTask resume];
    
}

+ (void)findUserByUsername:(NSString *)username forAPIKey:(NSString *)apiKey completion:(void(^)(NSString *userID, NSString *userName, NSError *error))completion
{
    //Check if arguments are present
    if (username == nil || apiKey == nil) {
        NSString *localUserID = nil;
        NSString *localUserName = nil;
        NSError *error = [[NSError alloc] init];
        completion(localUserID, localUserName, error);
    }
    
    //Download JSON data form Flickr
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *prepareURLString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.people.findByUsername&api_key=%@&format=json&nojsoncallback=1&username=%@", apiKey, username];
    NSString *urlString = [prepareURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *userQueryTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSString *localUserID = nil;
        NSString *localUserName = nil;
        if (!error) {
            //Download task was successful
            NSData *data = [NSData dataWithContentsOfURL:location];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            //Check server status code
            NSString *statusCode = [responseDictionary valueForKey:@"stat"];
            if ([statusCode isEqual:kFlickrAPIOKStatusCodeKey]) {
                //Load data
                localUserID = [responseDictionary valueForKeyPath:@"user.id"];
                localUserName = [responseDictionary valueForKeyPath:@"user.username._content"];
            } else error = [[NSError alloc] init];
        }
        completion(localUserID, localUserName, error);
    }];
    [userQueryTask resume];
}

@end
