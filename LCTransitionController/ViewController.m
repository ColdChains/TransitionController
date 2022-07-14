//
//  ViewController.m
//  LCTransitionController
//
//  Created by lax on 2022/5/24.
//

#import "ViewController.h"
#import "StartViewController.h"
#import "LCTransitionTabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (IBAction)pushAction:(id)sender {
    StartViewController *vc = [[StartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tabbarAction:(id)sender {
    LCTransitionTabBarController *vc = [[LCTransitionTabBarController alloc] init];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    UIViewController *vc2 = [[UIViewController alloc] init];
    UIViewController *vc3 = [[UIViewController alloc] init];
    UIViewController *vc4 = [[UIViewController alloc] init];
    UIViewController *vc5 = [[UIViewController alloc] init];
    vc1.title = @"a";
    vc2.title = @"b";
    vc3.title = @"c";
    vc4.title = @"d";
    vc5.title = @"e";
    vc1.view.backgroundColor = [UIColor blueColor];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc4.view.backgroundColor = [UIColor orangeColor];
    vc5.view.backgroundColor = [UIColor redColor];
    vc.viewControllers = @[vc1, vc2, vc3, vc4, vc5];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
