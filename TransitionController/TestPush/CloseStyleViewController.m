//
//  CloseStyleViewController.m
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "CloseStyleViewController.h"

@interface CloseStyleViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL isTransition;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CloseStyleViewController

- (QLTransitionStyle)transitionStyle {
    return QLTransitionStylePop | QLTransitionStylePush | QLTransitionStyleClose;
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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 375, 150)];
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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.bottomView];
}


// 开始转场
- (void)transitionViewController:(QLTransitionViewController *)vc willBeginTransition:(QLTransitionStyle)transitionStyle {
    if (transitionStyle & QLTransitionStyleCustom) {
        self.isTransition = YES;
    }
}

// 已经结束转场
- (void)transitionViewController:(QLTransitionViewController *)vc didEndTransition:(QLTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled {
    if (canceled && transitionStyle & QLTransitionStyleCustom) {
        self.isTransition = NO;
    }
}

/// 需要做转场的view
- (UIView *)transitionAnimationView {
    return self.imageView;
}

/// 添加转场手势view
- (UIView *)transitionGestureView {
    return self.imageView;
}

/// QLTransitionStyleClose结束动画时是否需要回到指定view的位置
- (BOOL)shouldResetAnimationAtEnd {
    return YES; // return currentIndex == startIndex;
}

@end
