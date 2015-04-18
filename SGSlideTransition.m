//
//  SGSlideTransition.m
//  NextSearch
//
//  Created by Simon Grätzer on 18.04.15.
//  Copyright (c) 2015 Simon Grätzer. All rights reserved.
//

#import "SGSlideTransition.h"

@implementation SGSlideTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext; {
    return 0.3;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext; {
    UIView *container = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL ingoing = _direction == SGSlideTransitionDirectionInRight || _direction == SGSlideTransitionDirectionInLeft;
    
    CGRect startFrame, endFrame;
    if (ingoing) {
        [container addSubview:toVC.view];
        startFrame = [transitionContext finalFrameForViewController:toVC];
        endFrame = startFrame;
    } else {
        startFrame = [transitionContext initialFrameForViewController:fromVC];
        endFrame = [transitionContext initialFrameForViewController:fromVC];
    }
    
    switch (_direction) {
        case SGSlideTransitionDirectionInRight:
            startFrame.origin.x = endFrame.size.width + container.bounds.size.width;
            break;
            
        case SGSlideTransitionDirectionInLeft:
            startFrame.origin.x = -endFrame.size.width;
            break;
            
        case SGSlideTransitionDirectionOutRight:
            endFrame.origin.x = endFrame.size.width + container.bounds.size.width;
            break;
            
        case SGSlideTransitionDirectionOutLeft:
            endFrame.origin.x = -endFrame.size.width;
            break;
    }
    if (ingoing) toVC.view.frame = startFrame;
    else fromVC.view.frame = startFrame;
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (ingoing) toVC.view.frame = endFrame;
                         else fromVC.view.frame = endFrame;
                     }
                     completion:^(BOOL finished) {
                         if (!ingoing) {
                             [fromVC.view removeFromSuperview];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
