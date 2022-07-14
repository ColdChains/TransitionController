//
//  LCTabBarAnimatedTransition.m
//  LCTransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "LCTabBarAnimatedTransition.h"

@interface LCTabBarAnimatedTransition ()

@end

@implementation LCTabBarAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat x = 0;
    if ([self.delegate respondsToSelector:@selector(directionWithFromViewController:toViewController:)]) {
        LCTabBarAnimatedDirection dir = [self.delegate directionWithFromViewController:fromVC toViewController:toVC];
        if (dir == LCTabBarAnimatedDirectionLeft) {
            x = -UIScreen.mainScreen.bounds.size.width;
        } else if (dir == LCTabBarAnimatedDirectionRight) {
            x = UIScreen.mainScreen.bounds.size.width;
        }
    }
    
    CGRect frame = toView.frame;
    frame.origin.x = x;
    toView.frame = frame;
    
    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform, -x, 0);
        toView.transform = CGAffineTransformTranslate(toView.transform, -x, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:YES];
            [fromView removeFromSuperview];
        }
    }];
    
}

@end
