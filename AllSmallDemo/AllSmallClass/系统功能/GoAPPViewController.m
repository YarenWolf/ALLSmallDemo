//
//  GoAPPViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GoAPPViewController.h"

@interface GoAPPViewController ()

@end

@implementation GoAPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"要首先配置info里面的URLTypes里面的URLSchemes");
    NSArray *titles = @[@"打电话",@"发短信",@"发邮件",@"浏览器",@"新浪微博",@"自己的程序"];
    for(int i=0;i<6;i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, TopHeight + i* 50, APPW-20, 40)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = redcolor;
        button.tag = i;
        [self.view addSubview:button];
    }
}
/** 跳转到YourApp的代码 */
- (void)gotoYourAppWithURLSchemes:(NSString*)schemes{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://aaa?backscheme=MyAppChemes",schemes]];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else{
        NSLog(@"打开应用程序失败");
    }
}
- (void)goToSina:(id)sender {
    NSURL *url = [NSURL URLWithString:@"sinaweibo://"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else{
        NSLog(@"打开应用程序失败");
    }
    
}
-(void)clicked:(UIButton*)sender{
    NSString *urlPath = nil;
    switch (sender.tag) {
        case 0://打电话
            urlPath = @"tel://10010";
            break;
        case 1://短信
            urlPath = @"sms://10010";
            break;
        case 2://邮件
            urlPath = @"mailto://abcd@163.com";
            break;
        case 3://浏览器
            urlPath = @"http://www.youku.com";
            break;
        case 4:{//新浪微博
            [self goToSina:nil];return;
        }
        case 5:{//自己程序
            [self gotoYourAppWithURLSchemes:@"YourAppScheme"];return;
        }
    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlPath]];
}
@end
