//
//  AppleSocialViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AppleSocialViewController.h"
#import <Social/Social.h>
@interface AppleSocialViewController ()

@end

@implementation AppleSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 1.判断sina的服务是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"改系统不支持新浪微博");
        return;
    }
    // 2.创建分享的控制器
    SLComposeViewController *cvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    // 设置数据
    [cvc setInitialText:@"这是一段用于测试苹果自带的社会化分享的代码"];
    [cvc addImage:[UIImage imageNamed:@"ball"]];
    // 3. 显示控制器
    [self  presentViewController:cvc animated:YES completion:nil];
    // 4. 设置block 监听
    cvc.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            NSLog(@"发送微博成功");
        }else{
            NSLog(@"取消发送");
        }
    };
}

@end
