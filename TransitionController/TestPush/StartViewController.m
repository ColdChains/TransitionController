//
//  StartViewController.m
//  TransitionViewController
//
//  Created by lax on 2022/5/23.
//

#import "StartViewController.h"
#import "CloseStyleViewController.h"
#import "CustomStyleViewController.h"

@interface StartViewController ()

@property (nonatomic, strong) UIView *animationView;

@end

@implementation StartViewController

- (QLTransitionStyle)transitionStyle {
    return QLTransitionStylePop | QLTransitionStylePush | QLTransitionStyleOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(88, 88, 100, 50)];
    imageView.image = [UIImage imageNamed:@"image"];
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(88, 188, 100, 50)];
    imageView.image = [UIImage imageNamed:@"image"];
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    imageView.tag = 100;
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    self.animationView = tap.view;
    if (tap.view.tag == 100) {
        CustomStyleViewController *vc = [[CustomStyleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    CloseStyleViewController *vc = [[CloseStyleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)transitionAnimationView {
    return self.animationView;
}

@end
