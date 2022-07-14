//
//  TransitionTabBarController.m
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "LCTransitionTabBarController.h"
#import "LCTabBarAnimatedTransition.h"

@interface LCTransitionTabBarController () <UITabBarControllerDelegate, LCTabBarAnimatedTransitionDelegate>

@end

@implementation LCTransitionTabBarController

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
    LCTabBarAnimatedTransition *transition = [[LCTabBarAnimatedTransition alloc] init];
    transition.delegate = self;
    return transition;
}

- (LCTabBarAnimatedDirection)directionWithFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC != toVC && [self.viewControllers containsObject:fromVC] && [self.viewControllers containsObject:toVC]) {
        return [self.viewControllers indexOfObject:toVC] > [self.viewControllers indexOfObject:fromVC] ? LCTabBarAnimatedDirectionRight : LCTabBarAnimatedDirectionLeft;
    }
    return LCTabBarAnimatedDirectionUnknow;
}

@end
