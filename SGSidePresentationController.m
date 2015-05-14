//
//  SGSidePresentationController.m
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

#import "SGSidePresentationController.h"

@implementation SGSidePresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController; {

    if(self = [super initWithPresentedViewController:presentedViewController
                            presentingViewController:presentingViewController]) {
        _screenFraction = 0.25;
        [self prepareDimmingView];
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    NSAssert(_dimmingView, @"Use initWithPresentedViewController:presentingViewController: to init this");
    
    // Here, we'll set ourselves up for the presentation
    UIView* containerView = [self containerView];
    UIViewController* presentedViewController = [self presentedViewController];
    
    // Make sure the dimming view is the size of the container's bounds, and fully transparent
    [_dimmingView setFrame:[containerView bounds]];
    [_dimmingView setAlpha:0.0];
    // Insert the dimming view below everything else
    [containerView insertSubview:_dimmingView atIndex:0];
    
    if([presentedViewController transitionCoordinator]) {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            // Fade the dimming view to be fully visible
            [_dimmingView setAlpha:1.0];
        } completion:nil];
    } else {
        [_dimmingView setAlpha:1.0];
    }
}

- (void)dismissalTransitionWillBegin {
    // Here, we'll undo what we did in -presentationTransitionWillBegin. Fade the dimming view to be fully transparent

    if([[self presentedViewController] transitionCoordinator]) {
        [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [_dimmingView setAlpha:0.0];
        } completion:nil];
    } else {
        [_dimmingView setAlpha:0.0];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyle {
    // When we adapt to a compact width environment, we want to be over full screen
    return UIModalPresentationOverFullScreen;
}

- (BOOL)shouldPresentInFullscreen {
    // This is a full screen presentation
    return YES;
}

- (CGSize)sizeForChildContentContainer:(id <UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    // We always want a size that's a fraction of our parent view width, and just as tall as our parent
    return CGSizeMake(floorf(parentSize.width * _screenFraction), parentSize.height);
}

- (void)containerViewWillLayoutSubviews {
    // Before layout, make sure our dimmingView and presentedView have the correct frame
    [_dimmingView setFrame:[[self containerView] bounds]];
    [[self presentedView] setFrame:[self frameOfPresentedViewInContainerView]];
}

- (CGRect)frameOfPresentedViewInContainerView {
    // Return a rect with the same size as -sizeForChildContentContainer:withParentContainerSize:, and right aligned
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = [self containerView].bounds;
    
    presentedViewFrame.size = [self sizeForChildContentContainer:(UIViewController<UIContentContainer> *)[self presentedViewController]
                                         withParentContainerSize:containerBounds.size];
    
    if (_sideMode == SGSidePresentationModeRigth) {
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
    }
    return presentedViewFrame;
}

- (void)prepareDimmingView {
    _dimmingView = [[UIView alloc] init];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [_dimmingView setAlpha:0.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [_dimmingView addGestureRecognizer:tap];
}

- (void)dimmingViewTapped:(UIGestureRecognizer *)gesture {
    if([gesture state] == UIGestureRecognizerStateRecognized) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end
