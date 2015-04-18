# Description 

Some presentation implementations I needed

#### Demo: SGSlideTransition + SGSidePresentationController

Used this in a project of mine to present a [CNPGridMenu](https://github.com/carsonperrotti/CNPGridMenu)
on top of my main view controller

![Slide demonstration](https://raw.githubusercontent.com/graetzer/SGPresentation/master/demo_slide.gif)

Uage example with ```CNPGridMenu```

    CNPGridMenu *gridMenu = [[CNPGridMenu alloc] initWithMenuItems:menuItems];
    //gridMenu.delegate = self;
    gridMenu.transitioningDelegate = self;
    gridMenu.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:gridMenu animated:YES completion:NULL];
    // ...
    #pragma mark - UIViewControllerTransitioningDelegate
    - (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                          presentingViewController:(UIViewController *)presenting
                                                              sourceViewController:(UIViewController *)source {
        return [[SGSidePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    }
    
    - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                      presentingController:(UIViewController *)presenting
                                                                          sourceController:(UIViewController *)source {
        return [SGSlideTransition new];
    }
    
    - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
        SGSlideTransition *slide = [SGSlideTransition new];
        slide.direction = SGSlideTransitionDirectionOutRight;
        return slide;
    }

# Licence 

   Copyright (c) 2015 Simon Grätzer

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
