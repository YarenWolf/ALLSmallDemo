//
//  AppleShareViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/4.
//  Copyright © 2017年 Super. All rights reserved.
//Share 这是苹果系统自带的社会分享，包括新浪微博，腾讯微博，Twitter，facebook，linkedin

#import "AppleShareViewController.h"
#import <Social/Social.h>

@interface AppleShareViewController ()

@end

@implementation AppleShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 新浪微博服务不可用
    //    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) return;
    //    SOCIAL_EXTERN NSString *const SLServiceTypeTwitter NS_AVAILABLE(10_8, 6_0);
    //    SOCIAL_EXTERN NSString *const SLServiceTypeFacebook NS_AVAILABLE(10_8, 6_0);
    //    SOCIAL_EXTERN NSString *const SLServiceTypeSinaWeibo NS_AVAILABLE(10_8, 6_0);
    //    SOCIAL_EXTERN NSString *const SLServiceTypeTencentWeibo NS_AVAILABLE(10_9, 7_0);
    //    SOCIAL_EXTERN NSString *const SLServiceTypeLinkedIn NS_AVAILABLE(10_9, NA);
    // 1.创建分享控制器
    SLComposeViewController *cvv = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    // 设置初始化数据
    [cvv setInitialText:@"郭XX xx xx -- 新闻链接：http://www.baidu.com/news/5435345"];
    [cvv addImage:[UIImage imageNamed:@"1"]];
    
    // 2.显示控制器
    [self presentViewController:cvv animated:YES completion:nil];
    
    // 3.设置block监听
    cvv.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"取消发送");
        } else {
            NSLog(@"发送完毕");
        }
    };
}

@end
