//
//  LCTabBarAnimatedTransition.h
//  LCTransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LCTabBarAnimatedDirection) {
    LCTabBarAnimatedDirectionUnknow,
    LCTabBarAnimatedDirectionLeft,
    LCTabBarAnimatedDirectionRight,
};

@protocol LCTabBarAnimatedTransitionDelegate <NSObject>

- (LCTabBarAnimatedDirection)directionWithFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

@end


@interface LCTabBarAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<LCTabBarAnimatedTransitionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
