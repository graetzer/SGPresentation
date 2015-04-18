//
//  SGSlideTransition.h
//  NextSearch
//
//  Created by Simon Grätzer on 18.04.15.
//  Copyright (c) 2015 Simon Grätzer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SGSlideTransitionDirection) {
    SGSlideTransitionDirectionInRight,
    SGSlideTransitionDirectionInLeft,
    SGSlideTransitionDirectionOutRight,
    SGSlideTransitionDirectionOutLeft
};

@interface SGSlideTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) SGSlideTransitionDirection direction;
@end
