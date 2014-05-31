//
//  FVNavigationBarAnimation.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVNavigationBarAnimation.h"

//Animation control keys
NSString *const kNavigationBarHide  = @"hideNavigationBar";
NSString *const kNavigationBarShow  = @"showNavigationBar";

@implementation FVNavigationBarAnimation

+ (void)changeNavigationBarState:(UINavigationController *)navigationController changeTo:(NSString *)state completion:(void(^)(BOOL navigationBarIsHidden))completion
{
    //Setup atributes
    UINavigationBar *navigationBar = navigationController.navigationBar;
    CGRect navBarOffset = navigationBar.frame;
    BOOL isHidden;
    
    if ([state isEqual:kNavigationBarHide]) {
        //NavigationBar will hide
        isHidden = YES;
        navBarOffset.origin.y -= navBarOffset.size.height;
        [UIView animateWithDuration:0.35 animations:^{
            navigationBar.frame = navBarOffset;
            [navigationController.navigationBar setAlpha:0.0];
        } completion:^(BOOL finished) {
            if (finished) {
                //Animation complete
            }
        }];
        
    } else if ([state isEqual:kNavigationBarShow]) {
        //NavigationBar will show
        isHidden = NO;
        navBarOffset.origin.y += navBarOffset.size.height;
        [UIView animateWithDuration:0.35 animations:^{
            navigationBar.frame = navBarOffset;
            [navigationController.navigationBar setAlpha:1.0];
        } completion:^(BOOL finished) {
            if (finished) {
                //Animation complete
            }
        }];
    }
    completion(isHidden);
}

@end
