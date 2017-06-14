//
//  UnlockViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "UnlockViewController.h"
#import "YZLockView.h"
@interface UnlockViewController()<YZLockViewDelegate>
@end
@implementation UnlockViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    YZLockView *view = [[YZLockView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    [self.view addSubview:view];
    view.delegate = self;
}
- (void)lockView:(YZLockView *)lockView didFinishPath:(NSString *)path{
    NSLog(@"拿到解锁路径---%@",path);
}

@end
