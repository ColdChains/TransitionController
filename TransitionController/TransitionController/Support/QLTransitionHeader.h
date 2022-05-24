//
//  QLTransitionHeader.h
//  QL
//
//  Created by lax on 2022/4/22.
//

#ifndef QLTransitionHeader_h
#define QLTransitionHeader_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, QLTransitionStyle) {
    QLTransitionStyleNone = 0,
    QLTransitionStylePush = 1 << 0,
    QLTransitionStylePop = 1 << 1,
    QLTransitionStyleCustom = 1 << 2,
    QLTransitionStyleOpen = 1 << 3, //
    QLTransitionStyleClose = 1 << 4, //
};

@class QLTransitionViewController;
@protocol QLAnimatedTransitionProtocol <NSObject>

@optional

/// 需要做转场的view
-(UIView *)transitionAnimationView;

/// 添加转场手势view
-(UIView *)transitionGestureView;

/// QLTransitionStyleClose结束动画时是否需要回到指定view的位置
-(BOOL)shouldResetAnimationAtEnd;

// 开始转场
- (void)transitionViewController:(QLTransitionViewController *)vc willBeginTransition:(QLTransitionStyle)transitionStyle;

// 正在转场
- (void)transitionViewController:(QLTransitionViewController *)vc transitioning:(QLTransitionStyle)transitionStyle panGesture:(UIPanGestureRecognizer *)sender progress:(CGFloat)progress;

// 是否允许结束转场 默认progress>0.5结束转场
- (BOOL)transitionViewController:(QLTransitionViewController *)vc transitioning:(QLTransitionStyle)transitionStyle shouldEndTransition:(CGFloat)progress;

// 将要结束转场
- (void)transitionViewController:(QLTransitionViewController *)vc willEndTransition:(QLTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled;

// 已经结束转场
- (void)transitionViewController:(QLTransitionViewController *)vc didEndTransition:(QLTransitionStyle)transitionStyle transitonStatus:(BOOL)canceled;

@end

NS_ASSUME_NONNULL_END

#endif /* QLTransitionHeader_h */
