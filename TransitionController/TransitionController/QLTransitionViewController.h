//
//  QLTransitionViewController.h
//  QL
//
//  Created by lax on 2022/4/21.
//

#import <UIKit/UIKit.h>
#import "QLTransitionHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLTransitionViewController : UIViewController <QLAnimatedTransitionProtocol>

// 转场样式
@property (nonatomic, assign, readonly) QLTransitionStyle transitionStyle;

@end

NS_ASSUME_NONNULL_END
