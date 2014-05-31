//
//  FVViewAnimation.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

//Animation control keys
extern NSString *const kViewAnimationStart; // Fade out and move
extern NSString *const kViewAnimationStop; // Fade in and move

@interface FVViewAnimations : NSObject

//Move up and fade elements
+ (void)moveTargetView:(UIView *)view forAction:(NSString *)action hideUnhideElements:(NSArray *)hide withUserInfo:(NSNotification *)info;

//Plain alpha animation
+ (void)fadeInOutElements:(NSArray *)elements forAction:(NSString *)action;

@end
