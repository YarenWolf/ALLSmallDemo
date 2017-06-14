//
//  GesturePWDViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GesturePWDViewController.h"
#import "CLLockVC.h"
@interface GesturePWDViewController ()
@end
@implementation GesturePWDViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *setPwd = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 30)];
    [setPwd setTitle:@"设置密码" forState:UIControlStateNormal];
    [setPwd addTarget:self action:@selector(setPwd:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *verifyPwd = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, 100, 30)];
    [verifyPwd setTitle:@"验证密码" forState:UIControlStateNormal];
    [verifyPwd addTarget:self action:@selector(verifyPwd:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *changePwd = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 100, 30)];
    [changePwd setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePwd addTarget:self action:@selector(modifyPwd:) forControlEvents:UIControlEventTouchUpInside];
    setPwd.backgroundColor = verifyPwd.backgroundColor =changePwd.backgroundColor = [UIColor redColor];
    [self.view addSubview:setPwd];
    [self.view addSubview:verifyPwd];
    [self.view addSubview:changePwd];
    
}
- (void)setPwd:(id)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    hasPwd = NO;
    if(hasPwd){
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    }else{
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}
- (void)verifyPwd:(id)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        NSLog(@"你还没有设置密码，请先设置密码");
    }else {
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            NSLog(@"忘记密码");
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码正确");
            [lockVC dismiss:1.0f];
        }];
    }
}
- (void)modifyPwd:(id)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        NSLog(@"你还没有设置密码，请先设置密码");
    }else {
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:.5f];
        }];
    }
}
@end

