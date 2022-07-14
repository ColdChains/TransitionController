//
//  CustomStyleViewController.m
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "CustomStyleViewController.h"

@interface CustomStyleViewController ()

@property (nonatomic, assign) BOOL isTransition;

@property (nonatomic, assign) CGRect startFrame;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CustomStyleViewController

- (LCTransitionStyle)transitionStyle {
    return LCTransitionStylePop | LCTransitionStylePush | LCTransitionStyleCustom;
}

- (void)setIsTransition:(BOOL)isTransition {
    if (_isTransition == isTransition) { return; }
    _isTransition = isTransition;
    if (isTransition) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.alpha = 1;
        }];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 188, 375, 150)];
        _imageView.image = [UIImage imageNamed:@"image"];
    }
    return _imageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 100, UIScreen.mainScreen.bounds.size.width, 100)];
        _bottomView.backgroundColor = [UIColor orangeColor];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.maskView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.maskView.backgroundColor = [UIColor darkTextColor];
    [self.view addSubview:self.maskView];
    
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.bottomView];
    
}


// 开始转场
- (void)transitionViewController:(LCTransitionViewController *)vc willBeginTransition:(LCTransitionStyle)transitionStyle {
    if (transitionStyle & LCTransitionStyleCustom) {
        self.isTransition = YES;
    }
}

// 正在转场
- (void)transitionViewController:(LCTransitionViewController *)vc transitioning:(LCTransitionStyle)transitionStyle panGesture:( UIPanGestureRecognizer *)sender progress:(CGFloat)progress {
    if (transitionStyle & LCTransitionStyleCustom) {
        if (CGRectIsEmpty(self.startFrame)) {
            self.startFrame = self.imageView.frame;
        }
        CGPoint panLocation = [sender translationInView:self.imageView.superview];
        float scale = MAX(.4, 1-progress/1.2);
        CGAffineTransform t = CGAffineTransformMakeTranslation(panLocation.x, panLocation.y);
        CGAffineTransform t1 = CGAffineTransformScale(t, scale, scale);
        self.imageView.transform = t1;
        self.maskView.alpha = MAX(0, 1-progress*2);
    }
}

// 是否结束转场
- (BOOL)transitionViewController:(LCTransitionViewController *)vc transitioning:(LCTransitionStyle)transitionStyle shouldEndTransition:(CGFloat)progress {
    return progress > 0.4;
}

// 将要结束转场
- (void)transitionViewController:(UIViewController *)vc willEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled {
    if (transitionStyle & LCTransitionStyleCustom) {
        if (canceled) {
            [UIView animateWithDuration:0.25 animations:^{
                CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
                self.imageView.transform = t;
                self.imageView.frame = self.startFrame;
                self.maskView.alpha = 1;
            }];
        }else {
            [UIView animateWithDuration:0.15 animations:^{
                self.view.alpha = 0;
            }];
        }
    }
}

// 已经结束转场
- (void)transitionViewController:(LCTransitionViewController *)vc didEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled {
    if (canceled && transitionStyle & LCTransitionStyleCustom) {
        self.isTransition = NO;
    }
}

/// 需要做转场的view
- (UIView *)transitionAnimationView {
    return self.imageView;
}

/// 添加转场手势view
- (UIView *)transitionGestureView {
    return nil;
//    return self.imageView;
}

@end
