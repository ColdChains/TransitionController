//
//  TabBarAnimatedTransition.h
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TabBarAnimationedDirection) {
    TabBarAnimationedDirectionUnknow,
    TabBarAnimationedDirectionLeft,
    TabBarAnimationedDirectionRight,
};

@protocol TabBarAnimatedTransitionDelegate <NSObject>

- (TabBarAnimationedDirection)directionWithFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

@end


@interface TabBarAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<TabBarAnimatedTransitionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
