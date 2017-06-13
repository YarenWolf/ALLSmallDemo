//
//  TransitionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()

@property (strong, nonatomic) UIImageView *iamgeView;

@property (nonatomic, assign) int index;
@end

@implementation TransitionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.iamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 100, 100, 100)];
    self.iamgeView.image = [UIImage imageNamed:@"loading_1"];
    [self.view addSubview:self.iamgeView];
    _index = 1;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _index++;
    if (_index == 13) { _index = 1;}
    _iamgeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",_index]];

    CATransition *anim = [CATransition animation];
    anim.type = @"pageCurl";
    anim.subtype = kCATransitionFromLeft;
    anim.duration = 2;
    [_iamgeView.layer addAnimation:anim forKey:nil];
    
    
//    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}
@end
