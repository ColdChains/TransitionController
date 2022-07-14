//
//  LCTransitionHeader.h
//  LCTransitionController
//
//  Created by lax on 2022/4/22.
//

#ifndef LCTransitionHeader_h
#define LCTransitionHeader_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LCTransitionStyle) {
    LCTransitionStyleNone = 0,
    LCTransitionStylePush = 1 << 0,
    LCTransitionStylePop = 1 << 1,
    LCTransitionStyleCustom = 1 << 2,
    LCTransitionStyleOpen = 1 << 3, //
    LCTransitionStyleClose = 1 << 4, //
};

@class LCTransitionViewController;
@protocol LCAnimatedTransitionProtocol <NSObject>

@optional

/// 需要做转场的view
-(UIView *)transitionAnimationView;

/// 添加转场手势view
-(UIView *)transitionGestureView;

/// LCTransitionStyleClose结束动画时是否需要回到指定view的位置
-(BOOL)shouldResetAnimationAtEnd;

// 开始转场
- (void)transitionViewController:(LCTransitionViewController *)vc willBeginTransition:(LCTransitionStyle)transitionStyle;

// 正在转场
- (void)transitionViewController:(LCTransitionViewController *)vc transitioning:(LCTransitionStyle)transitionStyle panGesture:(UIPanGestureRecognizer *)sender progress:(CGFloat)progress;

// 是否允许结束转场 默认progress>0.5结束转场
- (BOOL)transitionViewController:(LCTransitionViewController *)vc transitioning:(LCTransitionStyle)transitionStyle shouldEndTransition:(CGFloat)progress;

// 将要结束转场
- (void)transitionViewController:(LCTransitionViewController *)vc willEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled;

// 已经结束转场
- (void)transitionViewController:(LCTransitionViewController *)vc didEndTransition:(LCTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled;

@end

NS_ASSUME_NONNULL_END

#endif /* LCTransitionHeader_h */
