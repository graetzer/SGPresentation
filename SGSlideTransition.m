//
//  SGSlideTransition.m
//
//  Created by Simon Grätzer on 18.04.15.
//  Copyright (c) 2015 Simon Grätzer
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
