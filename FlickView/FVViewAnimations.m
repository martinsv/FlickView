//
//  FVViewAnimation.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVViewAnimations.h"

//Animation control keys
NSString *const kViewAnimationStart = @"keyboardWillShow";
NSString *const kViewAnimationStop = @"keyboardWillHide";

@implementation FVViewAnimations

+ (void)moveTargetView:(UIView *)view forAction:(NSString *)action hideUnhideElements:(NSArray *)hide withUserInfo:(NSNotification *)info
{
    if (view == nil || action == nil || info==nil) return;
    
    NSDictionary *userInfo = info.userInfo;
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if ([action isEqual:kViewAnimationStart]) {
        //KeyboardWillShow - Move view up
        CGFloat viewOffsetY = (view.bounds.size.height /2 - (view.bounds.size.height - keyboardFrameEnd.size.height) /2) /2; //Calculate view's new Y center, with keyboard extended. Divide offsetValue by 2 for visual purposes.
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | (curve << 16) animations:^{
            //Hide elements
            for (int x = 0; x < [hide count]; x++) {
                UIView *element = (UIView *)hide[x];
                element.alpha = 0;
            }
            //Move up target view
            CGRect newFrame = view.frame;
            newFrame.origin.y -= viewOffsetY;
            view.frame = newFrame;
        } completion:nil];
        
    } else if ([action isEqual:kViewAnimationStop]) {
        //KeyboardWillHide - Move back
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | (curve << 16) animations:^{
            //Unhide elements
            for (int x = 0; x < [hide count]; x++) {
                UIView *element = (UIView *)hide[x];
                element.alpha = 1.0;
            }
            //Move back target view
            CGRect newFrame = view.bounds;
            view.frame = newFrame;
        } completion:nil];
    }
}

+ (void)fadeInOutElements:(NSArray *)elements forAction:(NSString *)action
{
    if ([action isEqual:kViewAnimationStart]) {
        //Hide elements
        [UIView animateWithDuration:0.35 animations:^{
            for (int x = 0; x < [elements count]; x++) {
                UIView *element = (UIView *)elements[x];
                element.alpha = 0.0;
            }
        } completion:nil];
        
    } else if ([action isEqual:kViewAnimationStop]) {
        //Unhide elements
        [UIView animateWithDuration:0.35 animations:^{
            for (int x = 0; x < [elements count]; x++) {
                UIView *element = (UIView *)elements[x];
                element.alpha = 1.0;
            }
        } completion:nil];
    }
}

@end
