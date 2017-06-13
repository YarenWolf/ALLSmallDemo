//
//  AnimationsViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AnimationsViewController.h"
@interface AnimationsViewController ()
@property (strong, nonatomic) UIView *redView;
@end
@implementation AnimationsViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(20, TopHeight, 200, 30)];
    self.redView.backgroundColor = redcolor;
    [self.view addSubview:self.redView];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @M_PI_2;
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 250)];
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @0.5;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[rotation,position,scale];
    group.duration = 2;
    // 取消反弹
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [_redView.layer addAnimation:group forKey:nil];
}

@end
