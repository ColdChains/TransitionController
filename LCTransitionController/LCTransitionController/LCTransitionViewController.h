//
//  LCTransitionViewController.h
//  LCTransitionController
//
//  Created by lax on 2022/4/21.
//

#import <UIKit/UIKit.h>
#import "LCTransitionHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCTransitionViewController : UIViewController <LCAnimatedTransitionProtocol>

// 转场样式
@property (nonatomic, assign, readonly) LCTransitionStyle transitionStyle;

@end

NS_ASSUME_NONNULL_END
