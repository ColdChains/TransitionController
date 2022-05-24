//
//  QLAnimatedTransition.h
//  QL
//
//  Created by lax on 2022/4/21.
//

#import <UIKit/UIKit.h>
#import "QLTransitionHeader.h"

typedef void(^TransitonCompleteBlock)(BOOL canceled);

NS_ASSUME_NONNULL_BEGIN

@interface QLAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning, QLAnimatedTransitionProtocol>

@property (nonatomic, assign, readonly) QLTransitionStyle transitionStyle;

// 取消转场剩余动画时间 默认0.15s
@property (nonatomic, assign) float transitionCancelAnimationDuration;

// 完成转场剩余动画时间 默认0.25s
@property (nonatomic, assign) float transitionFinishAnimationDuration;

// 需要处理移动手势的view
@property (nonatomic, strong, readonly) UIView *panAnimationView;

- (instancetype)initWithTransitionStyle:(QLTransitionStyle)transitionStyle complete:(TransitonCompleteBlock _Nullable)completeBlock;

@end

NS_ASSUME_NONNULL_END
