//
//  LCAnimatedTransition.h
//  LCTransitionController
//
//  Created by lax on 2022/4/21.
//

#import <UIKit/UIKit.h>
#import "LCTransitionHeader.h"

typedef void(^TransitonCompleteBlock)(BOOL canceled);

NS_ASSUME_NONNULL_BEGIN

@interface LCAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning, LCAnimatedTransitionProtocol>

@property (nonatomic, assign, readonly) LCTransitionStyle transitionStyle;

// 取消转场剩余动画时间 默认0.15s
@property (nonatomic, assign) float transitionCancelAnimationDuration;

// 完成转场剩余动画时间 默认0.25s
@property (nonatomic, assign) float transitionFinishAnimationDuration;

// 需要处理移动手势的view
@property (nonatomic, strong, readonly) UIView *panAnimationView;

- (instancetype)initWithTransitionStyle:(LCTransitionStyle)transitionStyle complete:(TransitonCompleteBlock _Nullable)completeBlock;

@end

NS_ASSUME_NONNULL_END
