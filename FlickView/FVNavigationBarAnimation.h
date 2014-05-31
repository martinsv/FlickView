//
//  FVNavigationBarAnimation.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

//Animation control keys
extern NSString *const kNavigationBarHide;
extern NSString *const kNavigationBarShow;

@interface FVNavigationBarAnimation : NSObject

+ (void)changeNavigationBarState:(UINavigationController *)navigationController changeTo:(NSString *)state completion:(void(^)(BOOL navigationBarIsHidden))completion;

@end
