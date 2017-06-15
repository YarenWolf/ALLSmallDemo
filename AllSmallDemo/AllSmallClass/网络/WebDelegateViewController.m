//
//  WebDelegateViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "WebDelegateViewController.h"
@interface WebDelegateViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *myWV;
@property (strong, nonatomic) UITextField *myTF;
@property (nonatomic, strong)UIAlertView *alertView;
@end

@implementation WebDelegateViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.myTF = [[UITextField alloc]initWithFrame:CGRectMake(10, TopHeight, APPW-20, 30)];
    self.myTF.layer.borderWidth = 1;
    self.myTF.placeholder = @"www.baidu.com";
    NSArray *titles = @[@"访问",@"前进",@"后退",@"刷新",@"停止"];
    for(int i=0;i<5;i++){
        UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(80*i, YH(_myTF)+10, 80, 30)];
        [b setTitle:titles[i] forState:UIControlStateNormal];
        b.backgroundColor = redcolor;
        b.tag = i;
        [b addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
    }
    self.myWV = [[UIWebView alloc]initWithFrame:CGRectMake(0, YH(_myTF)+50, APPW, APPH-YH(_myTF)-100)];
    [self.view addSubview:_myTF];
    [self.view addSubview:_myWV];
}

- (void)go:(UIButton*)sender {
    NSString *path = self.myTF.text;
    switch (sender.tag) {
        case 0:{
            if (![path hasPrefix:@"http://"]) {path = [@"http://" stringByAppendingString:path];}
            NSURL *url = [NSURL URLWithString:path];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [self.myWV loadRequest:request];
            [self.myTF resignFirstResponder];
        }break;
        case 1:{
            [self.myWV goForward];
        }break;
        case 2:{
            [self.myWV goBack];
        }break;
        case 3:{
            [self.myWV reload];
        }break;
        case 4:{
            [self.myWV stopLoading];
        }break;
        default:
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *path = [request.URL description];
    //    判断是否包含字符串
    if ([path rangeOfString:@"baidu"].length>0) {
        return YES;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不允许访问百度以外的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    return NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //    每次显示之前都把之前显示的删除掉
    if (self.alertView.isVisible) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    self.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在加载，请稍后。。。" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [self.alertView show];
    NSLog(@"开始显示");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"关闭显示");
}
@end

