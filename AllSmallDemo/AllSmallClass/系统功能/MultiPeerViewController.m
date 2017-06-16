//
//  MultiPeerViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "MultiPeerViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface MultiPeerViewController ()<MCSessionDelegate,MCAdvertiserAssistantDelegate,MCBrowserViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UIButton *browserButton;
@property (strong, nonatomic) UITextField *chatBox;
@property (strong, nonatomic) UITextView *textBox;
// 设备id
@property (strong,nonatomic) MCPeerID *myPerrID;
// 连接会话
@property(strong,nonatomic) MCSession *mySession;
// 向用户提供邀请 处理用户的响应
@property(strong,nonatomic) MCAdvertiserAssistant *advertiserAssistant;
// 选择会话控制器
@property (strong,nonatomic) MCBrowserViewController *browserViewController;
@end

@implementation MultiPeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatBox = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 300, 30)];
    self.chatBox.backgroundColor = [UIColor grayColor];
    self.browserButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, 300, 30)];
    [self.browserButton setTitle:@"开始浏览" forState:UIControlStateNormal];
    self.browserButton.backgroundColor = [UIColor redColor];
    [self.browserButton addTarget:self action:@selector(browserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.textBox = [[UITextView alloc]initWithFrame:CGRectMake(10, 200, 300, 300)];
    self.textBox.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.chatBox];
    [self.view addSubview:self.browserButton];
    [self.view addSubview:self.textBox];
    // 基本设置
    [self  setupMutipeer];
    self.chatBox.delegate = self;
}
static NSString *ServiceType = @"chat";
- (void) setupMutipeer{
    self.myPerrID = [[MCPeerID alloc]initWithDisplayName:[UIDevice currentDevice].name];
    self.mySession = [[MCSession alloc]initWithPeer:self.myPerrID];
    self.advertiserAssistant = [[MCAdvertiserAssistant alloc]initWithServiceType: ServiceType discoveryInfo:nil session:self.mySession];
    self.browserViewController = [[MCBrowserViewController alloc]initWithServiceType:ServiceType session:self.mySession];
    self.browserViewController.delegate = self;
    self.mySession.delegate = self;
    [self.advertiserAssistant start];
}
// 显示控制器view
- (void) showBroserVc{
    [self presentViewController:self.browserViewController animated:YES completion:nil];
}
//取消控制器
- (void) dismissBrowserVc{
    [self.browserViewController dismissViewControllerAnimated:YES completion:nil];
}
// 点击browser按钮
- (void)browserBtnClick:(id)sender {
    [self showBroserVc];
}
// 发送文本
- (void) sendText{
    NSString *message = self.chatBox.text;
    self.chatBox.text = @"";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 通过会话发送
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers]  withMode:MCSessionSendDataReliable error:nil];
    // 收取数据
    [self reciveMessage:message fromPeer:self.myPerrID];
}
// 收取数据
- (void)reciveMessage:(NSString*) message fromPeer:(MCPeerID*) perrid{
    NSString *finalMessage = nil;
    if (perrid == self.myPerrID) {
        finalMessage = [NSString stringWithFormat:@"\nMe:%@\n",message];
    }else{
        finalMessage = [NSString stringWithFormat:@"\n%@:%@\n",perrid.displayName,message];
    }
    self.textBox.text = [self.textBox.text stringByAppendingString:finalMessage];
}
#pragma mark MCBroserControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVc];
}
- (void) browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVc];
}
#pragma  mark  文本框的代理
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}
// session 的代理方法
- (void) session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSString *message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reciveMessage:message fromPeer:peerID];
    });
}
- (void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
@end








