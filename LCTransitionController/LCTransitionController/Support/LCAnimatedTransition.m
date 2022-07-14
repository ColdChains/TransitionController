//
//  LCAnimatedTransition.m
//  LCTransitionController
//
//  Created by lax on 2022/4/21.
//

#import "LCAnimatedTransition.h"

@interface LCAnimatedTransition ()

@property (nonatomic, assign) LCTransitionStyle transitionStyle;

// 转场完成回调
@property (nonatomic, copy) TransitonCompleteBlock complteBlock;

@end

@implementation LCAnimatedTransition

- (instancetype)initWithTransitionStyle:(LCTransitionStyle)transitionStyle complete:(TransitonCompleteBlock _Nullable)completeBlock
{
    self = [super init];
    if (self) {
        self.complteBlock = completeBlock;
        self.transitionStyle = transitionStyle;
        self.transitionCancelAnimationDuration = 0.15;
        self.transitionFinishAnimationDuration = 0.25;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return self.transitionStyle == LCTransitionStyleCustom ? .35 : 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView *fromAnimationView = nil;
    UIView *toAnimationView = nil;
    
    if ([fromVC conformsToProtocol:@protocol(LCAnimatedTransitionProtocol)] && [fromVC respondsToSelector:@selector(transitionAnimationView)]) {
        fromAnimationView = [(id <LCAnimatedTransitionProtocol>)fromVC transitionAnimationView];
    }
    if ([toVC conformsToProtocol:@protocol(LCAnimatedTransitionProtocol)] && [fromVC respondsToSelector:@selector(transitionAnimationView)]) {
        toAnimationView = [(id <LCAnimatedTransitionProtocol>)toVC transitionAnimationView];
    }
    
    switch (self.transitionStyle) {
        case LCTransitionStyleNone: {
            break;
        }
        case LCTransitionStylePush: {
            [containerView addSubview:toView];
            toView.frame = CGRectMake(width, 0, width, height);
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toView.frame = CGRectMake(0, 0, width, height);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            break;
        }
        case LCTransitionStylePop:{
            [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
            fromView.frame = CGRectMake(0, 0, width, height);
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromView.frame = CGRectMake(width, 0, width, height);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            break;
        }
        case LCTransitionStyleOpen: {
            [containerView addSubview:toView];
            
            CGRect frame = toAnimationView.frame;
            toAnimationView.frame = fromAnimationView.frame;
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toAnimationView.frame = frame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            
            break;
        }
        case LCTransitionStyleClose: {
            [containerView addSubview:toView];
            
            UIView *fromSnapView = [fromAnimationView snapshotViewAfterScreenUpdates:YES];
            _panAnimationView = fromSnapView;
            CGRect startRect = [fromAnimationView convertRect:fromAnimationView.bounds toView:containerView];;
            fromSnapView.frame = startRect;
            UIView *view = [[UIView alloc]initWithFrame:containerView.bounds];
            view.backgroundColor = [UIColor blackColor];
            [containerView addSubview:view];
            [containerView addSubview:fromSnapView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                CGRect toViewRect = [toAnimationView convertRect:toAnimationView.bounds toView:containerView];
                BOOL shouldReset = [(id <LCAnimatedTransitionProtocol>)fromVC shouldResetAnimationAtEnd];
                if (!shouldReset) {
                    toViewRect = CGRectMake(containerView.center.x, containerView.center.y, 0, 0);
                }
                [UIView animateWithDuration:transitionContext.transitionWasCancelled ? self.transitionCancelAnimationDuration : self.transitionFinishAnimationDuration animations:^{
                    self.panAnimationView.transform = CGAffineTransformMakeScale(1, 1);
                    self.panAnimationView.frame = transitionContext.transitionWasCancelled ? startRect : toViewRect;
                    fromView.alpha = 1;
                } completion:^(BOOL finished) {
                    [self.panAnimationView removeFromSuperview];
                    [view removeFromSuperview];
                    if (self.complteBlock) {
                        self.complteBlock(transitionContext.transitionWasCancelled);
                    }
                    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                }];
            }];
            
            break;
        }
        case LCTransitionStyleCustom: {
            [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
            
            UIView *view = [[UIView alloc] init];
            [[transitionContext containerView] addSubview:view];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                if (self.complteBlock) {
                    self.complteBlock(transitionContext.transitionWasCancelled);
                }
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
            
            break;
        }
    }
    
}

@end
