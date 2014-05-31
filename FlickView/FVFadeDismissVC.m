//
//  FVFadeDismissVC.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVFadeDismissVC.h"

@implementation FVFadeDismissVC

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //Setup transitionContext
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //Set frames
    toVC.view.frame = containerView.frame;
    fromVC.view.frame = containerView.frame;
    
    //Add subviews
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView addSubview:fromVC.view];
    
    //Prepare VC for animation
    fromVC.view.alpha = 1.0;
    
    //Do animation
    [UIView animateWithDuration:0.3 animations:^{
        fromVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        //Animation complete
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
