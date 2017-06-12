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
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self gotoYourAppWithURLSchemes:@"YourAppScheme"];
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

@end
