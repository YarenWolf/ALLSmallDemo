//
//  SendMessageViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved
#import "SendMessageViewController.h"
#import <MessageUI/MessageUI.h>
@interface SendMessageViewController ()<MFMessageComposeViewControllerDelegate>
@end
@implementation SendMessageViewController
#pragma mark MFMessageComposeViewControllerDelegate
- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:NSLog(@"发送成功");break;
        case MessageComposeResultFailed:NSLog(@"发送成功");break;
        case MessageComposeResultCancelled:NSLog(@"取消发送");break;
        default:break;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    NSURL *url = [NSURL URLWithString:@"sms://15811005943"];
    //    [[UIApplication sharedApplication]openURL:url];
    [self showMessageView:@[@"15811005943"] title:@"短信标题" body:@"测试发短信"];
}
/** 完成发短信 */
- (void) showMessageView:(NSArray*)phones title:(NSString*) title body:(NSString*) body{
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *msgController = [[MFMessageComposeViewController alloc]init];
        msgController.recipients = phones;
        msgController.body = body;
        msgController.title = title;
        msgController.messageComposeDelegate = self;
        msgController.navigationBar.tintColor = [UIColor redColor];
        [self presentViewController:msgController animated:YES completion:nil];
    }else{
        NSLog(@"此设备不支持发短信");
    }
}
@end
