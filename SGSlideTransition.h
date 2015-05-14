//
//  SGSlideTransition.h
//  NextSearch
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
