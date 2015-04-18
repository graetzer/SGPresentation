//
//  SGSidePresentationController.m
//
//  Created by Simon Grätzer on 18.04.15.
//  Copyright (c) 2015 Simon Grätzer. All rights reserved.
//

#import "SGSidePresentationController.h"

@implementation SGSidePresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController; {

    if(self = [super initWithPresentedViewController:presentedViewController
                            presentingViewController:presentingViewController]) {
        
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
    // We always want a size that's a third of our parent view width, and just as tall as our parent
    return CGSizeMake(floorf(parentSize.width / 4.0), parentSize.height);
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
    
    presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
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
