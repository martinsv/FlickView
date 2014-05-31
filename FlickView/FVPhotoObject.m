//
//  FVPhotoObject.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVPhotoObject.h"
#import <SDWebImageDecoder.h>
#import <SDWebImageManager.h>
#import <SDWebImageOperation.h>

//Thumb photo keys - initWithStyle
NSString *const kFlickrThumbStylePhoto           = @"photoThumb";
NSString *const kFlickrThumbStylePhotoset        = @"photosetThumb";

//Flickr JSON response keys
static NSString *const kFlickrAPIPhotoIDKey             = @"id";
static NSString *const kFlickrAPIPhotosetPrimaryIDKey   = @"primary";
static NSString *const kFlickrAPIPhotosetPhotoCount     = @"photos";
static NSString *const kFlickrAPIPhotoSecretKey         = @"secret";
static NSString *const kFlickrAPIPhotoServerKey         = @"server";
static NSString *const kFlickrAPIPhotoFarmKey           = @"farm";
static NSString *const kFlickrAPIPhotoTitleKey          = @"title";
static NSString *const kFlickrAPIPhotosetTitleKey       = @"title._content";
static NSString *const kFlickrAPIPhotoSizeThumbKey      = @"q";
static NSString *const kFlickrAPIPhotoSizeLargeKey      = @"b";

@interface FVPhotoObject()

@property (nonatomic) BOOL loadingInProgress;
@property (nonatomic) BOOL thumbLoadingInProgres;
@property (nonatomic) id <SDWebImageOperation> webImageOperation;

@end

@implementation FVPhotoObject

@synthesize underlyingImage = _underlyingImage; // synth property from protocol

-(id)init
{
    self = [self initWithData:nil andStyle:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data andStyle:(NSString *)style
{
    self = [super init];
    
    if ([style isEqual:kFlickrThumbStylePhotoset]) {
        //Style - Photoset
        self.photoID = data[kFlickrAPIPhotosetPrimaryIDKey];
        self.photosetID = data[kFlickrAPIPhotoIDKey];
        self.photoTitle = [data valueForKeyPath:kFlickrAPIPhotosetTitleKey];
        self.photosetPhotoCount = data[kFlickrAPIPhotosetPhotoCount];
    }
    else if ([style isEqual:kFlickrThumbStylePhoto]) {
        //Style - Photo
        self.photoID = data[kFlickrAPIPhotoIDKey];
        self.photoTitle = data[kFlickrAPIPhotoTitleKey];
    }
    self.photoFarm = data[kFlickrAPIPhotoFarmKey];
    self.photoServer = data[kFlickrAPIPhotoServerKey];
    self.photoSecret = data[kFlickrAPIPhotoSecretKey];
    
    //Build image URLs
    self.largeImageURL = [self buildImageURL:kFlickrAPIPhotoSizeLargeKey];
    self.thumbImageURL = [self buildImageURL:kFlickrAPIPhotoSizeThumbKey];
    
    return self;
}

#pragma mark - Helper Methods

- (NSURL *)buildImageURL:(NSString *)size
{
    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", self.photoFarm, self.photoServer, self.photoID, self.photoSecret, size];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

#pragma mark - UICollectionView Methods

- (void)loadThumbImageAndNotify
{
    //Check if loading is in progress
    if (_thumbLoadingInProgres) return;
    _thumbLoadingInProgres = YES;
    
    //Check if image already exists
    if (_thumbImage) { [self thumbImageLoadingComplete];}
    else [self performLoadThumbImageAndNotify];
    
}
- (void)performLoadThumbImageAndNotify
{
    if (_thumbImageURL) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        _webImageOperation = [manager downloadWithURL:_thumbImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!error) {
                _webImageOperation = nil;
                self.thumbImage = image;
                [self thumbImageLoadingComplete];
            } else NSLog(@"Error downloading thumb image");
        }];
    } else NSLog(@"Thumb image URL missing");
}

- (void)thumbImageLoadingComplete
{
    _thumbLoadingInProgres = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:FVPHOTO_THUMB_DID_END_LOADING
                                                        object:nil];
}

#pragma mark - MWPhotoBrowser Delegates

- (UIImage *)underlyingImage
{
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify
{
    //Check if loading is in progress
    if (_loadingInProgress) return;
    _loadingInProgress = YES;
    
    //Check if image already exists
    if (self.largeImage) {
        self.underlyingImage = self.largeImage;
        [self imageLoadingComplete];
    } else {
        [self performLoadUnderlyingImageAndNotify];
    }
}

- (void)performLoadUnderlyingImageAndNotify
{
    if (_largeImageURL) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        _webImageOperation = [manager downloadWithURL:_largeImageURL
                                              options:0
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                 if (expectedSize > 0) {
                                                     float progress = receivedSize / (float)expectedSize;
                                                     NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                           [NSNumber numberWithFloat:progress], @"progress",
                                                                           self, @"photo", nil];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
                                                 }
                                             }
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                if (!error) {
                                                    _webImageOperation = nil;
                                                    self.underlyingImage = image;
                                                    [self imageLoadingComplete];
                                                } else NSLog(@"Error downloading large image");
                                            }];
    } else NSLog(@"Large image URL missing");
}
- (void)imageLoadingComplete
{
    _loadingInProgress = NO;
    self.largeImage = self.underlyingImage;
    // Notify on next run loop
    [self performSelector:@selector(postCompleteNotification) withObject:nil afterDelay:0];
}

- (void)postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (NSString *)caption
{
    if (self.photoTitle) return self.photoTitle;
    return nil;
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
	self.underlyingImage = nil;
    self.largeImage = nil;
}

- (void)cancelAnyLoading {
    if (_webImageOperation) {
        [_webImageOperation cancel];
        _loadingInProgress = NO;
    }
}

@end
