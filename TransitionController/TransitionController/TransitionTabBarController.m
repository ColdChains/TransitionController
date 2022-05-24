//
//  TransitionTabBarController.m
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "TransitionTabBarController.h"
#import "TabBarAnimatedTransition.h"

@interface TransitionTabBarController () <UITabBarControllerDelegate, TabBarAnimatedTransitionDelegate>

@end

@implementation TransitionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.delegate = nil;
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    TabBarAnimatedTransition *transition = [[TabBarAnimatedTransition alloc] init];
    transition.delegate = self;
    return transition;
}

- (TabBarAnimationedDirection)directionWithFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC != toVC && [self.viewControllers containsObject:fromVC] && [self.viewControllers containsObject:toVC]) {
        return [self.viewControllers indexOfObject:toVC] > [self.viewControllers indexOfObject:fromVC] ? TabBarAnimationedDirectionRight : TabBarAnimationedDirectionLeft;
    }
    return TabBarAnimationedDirectionUnknow;
}

@end
