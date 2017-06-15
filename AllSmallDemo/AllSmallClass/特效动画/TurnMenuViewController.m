//
//  TurnMenuViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "TurnMenuViewController.h"
#import "EFAnimationViewController.h"
@interface TurnMenuViewController ()
@property (nonatomic, strong) EFAnimationViewController *viewController;
@end
@implementation TurnMenuViewController
- (void)dealloc {
    [_viewController.view removeFromSuperview];
    [_viewController removeFromParentViewController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    EFAnimationViewController *viewController = [[EFAnimationViewController alloc] init];
    viewController.images = @[@"1", @"2", @"3", @"4", @"0"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
}
@end

