//
//  LCTransitionViewController.m
//  LCTransitionController
//
//  Created by lax on 2022/4/21.
//

#import "LCTransitionViewController.h"
#import "LCAnimatedTransition.h"

@interface LCTransitionViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, strong) LCAnimatedTransition *animatedTransition;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGRect startFrame;

@end

@implementation LCTransitionViewController

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (LCTransitionStyle)transitionStyle {
    return LCTransitionStylePop | LCTransitionStylePush;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.transitionStyle & LCTransitionStylePop ||
        self.transitionStyle & LCTransitionStyleClose ||
        self.transitionStyle & LCTransitionStyleCustom) {
        self.transitionGestureView.userInteractionEnabled = YES;
        [self.transitionGestureView ?: self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    CGFloat progress = 0;
    if (self.startPoint.x <= 44) {
        progress = [sender translationInView:self.view].x / [UIScreen mainScreen].bounds.size.width;
    } else {
        progress = [sender translationInView:self.view].y / [UIScreen mainScreen].bounds.size.width;
    }
    progress = MIN(1.0, (MAX(0.0, fabs(progress))));
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [sender locationInView:self.view];
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        [self.navigationController popViewControllerAnimated:YES];
        if ([self respondsToSelector:@selector(transitionViewController:willBeginTransition:)]) {
            [self transitionViewController:self willBeginTransition:[self getPoptransitionStyle]];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.interactiveTransition updateInteractiveTransition:progress];
        if ([self respondsToSelector:@selector(transitionViewController:transitioning:panGesture:progress:)]) {
            [self transitionViewController:self transitioning:self.animatedTransition.transitionStyle panGesture:sender progress:progress];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        BOOL end = progress > 0.5;
        if ([self respondsToSelector:@selector(transitionViewController:transitioning:shouldEndTransition:)]) {
            end = [self transitionViewController:self transitioning:self.animatedTransition.transitionStyle shouldEndTransition:progress];
        }
        if (end) {
            [self.interactiveTransition finishInteractiveTransition];
            self.interactiveTransition = nil;
            if ([self respondsToSelector:@selector(transitionViewController:willEndTransition:transitonStatus:)]) {
                [self transitionViewController:self willEndTransition:self.animatedTransition.transitionStyle transitonStatus:NO];
            }
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
            self.interactiveTransition = nil;
            if ([self respondsToSelector:@selector(transitionViewController:willEndTransition:transitonStatus:)]) {
                [self transitionViewController:self willEndTransition:self.animatedTransition.transitionStyle transitonStatus:YES];
            }
        }
    } else {
        [self.interactiveTransition cancelInteractiveTransition];
        self.interactiveTransition = nil;
        if ([self respondsToSelector:@selector(transitionViewController:willEndTransition:transitonStatus:)]) {
            [self transitionViewController:self willEndTransition:self.animatedTransition.transitionStyle transitonStatus:NO];
        }
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[LCAnimatedTransition class]]) {
        return self.interactiveTransition;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    LCTransitionStyle style = LCTransitionStyleNone;
    if (operation == UINavigationControllerOperationPush) {
        if (self.transitionStyle & LCTransitionStyleOpen) {
            style = LCTransitionStyleOpen;
        }
    } else if (operation == UINavigationControllerOperationPop) {
        style = [self getPoptransitionStyle];
    }
    if (style) {
        __weak typeof(self) weakSelf = self;
        self.animatedTransition = [[LCAnimatedTransition alloc] initWithTransitionStyle:style complete:^(BOOL canceled) {
            if ([weakSelf respondsToSelector:@selector(transitionViewController:didEndTransition:transitonStatus:)]) {
                [weakSelf transitionViewController:weakSelf didEndTransition:style transitonStatus:canceled];
            }
        }];
    } else {
        self.animatedTransition = nil;
    }
    return self.animatedTransition;
}

- (LCTransitionStyle)getPoptransitionStyle {
    if (!self.interactiveTransition) {
        return LCTransitionStylePop;
    }
    if (self.transitionStyle & LCTransitionStyleClose) {
        return LCTransitionStyleClose;
    }
    // startPoint在左侧用pop 在右侧用move
    if (self.transitionStyle & LCTransitionStyleCustom && self.startPoint.x > 44) {
        return LCTransitionStyleCustom;
    }
    return LCTransitionStylePop;
}

// 开始转场
- (void)transitionViewController:(LCTransitionViewController *)vc willBeginTransition:(LCTransitionStyle)transitionStyle {
    
}

// 正在转场
- (void)transitionViewController:(UIViewController *)vc transitioning:(LCTransitionStyle)transitionStyle panGesture:(UIPanGestureRecognizer *)sender progress:(CGFloat)progress {
    if (CGRectIsEmpty(self.startFrame)) {
        self.startFrame = self.animatedTransition.panAnimationView.frame;
    }
    CGPoint panLocation = [sender translationInView:self.animatedTransition.panAnimationView.superview];
    float scale = MAX(.4, 1-progress/1.2);
    CGAffineTransform t = CGAffineTransformMakeTranslation(panLocation.x, panLocation.y);
    CGAffineTransform t1 = CGAffineTransformScale(t, scale, scale);
    self.animatedTransition.panAnimationView.transform = t1;
}

// 是否允许结束转场 默认progress>0.5结束转场
- (BOOL)transitionViewController:(LCTransitionViewController *)vc transitioning:(LCTransitionStyle)transitionStyle shouldEndTransition:(CGFloat)progress {
    return progress > 0.5;
}

// 将要结束转场
- (void)transitionViewController:(LCTransitionViewController *)vc willEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled {
    
}

// 已经结束转场，即转场动画彻底结束
- (void)transitionViewController:(LCTransitionViewController *)vc didEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled {
    
}

/// 需要做转场的view
- (UIView *)transitionGestureView {
    return nil;
}

/// 添加转场手势view
- (UIView *)transitionAnimationView {
    return nil;
}

/// LCTransitionStyleClose结束动画时是否需要回到指定view的位置
- (BOOL)shouldResetAnimationAtEnd {
    return YES;
}

@end

