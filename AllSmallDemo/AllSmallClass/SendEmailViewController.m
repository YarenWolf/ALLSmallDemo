//
//  SendEmailViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "SendEmailViewController.h"
#import <MessageUI/MessageUI.h>
@interface SendEmailViewController ()<MFMailComposeViewControllerDelegate>
@end

@implementation SendEmailViewController
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:NSLog(@"发送成功");break;
        case MFMailComposeResultFailed:NSLog(@"发送失败");break;
        default:break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([MFMailComposeViewController canSendMail]) {
        NSLog(@"发送邮件");
        MFMailComposeViewController *mailCon = [MFMailComposeViewController new];
        [mailCon setSubject:@"我的周报"];
        [mailCon setToRecipients:@[@"2829969299@qq.com"]];
        // cc 抄送
        /* mailCon setCcRecipients: */
        // bcc
        [mailCon setMessageBody:@"这是我的周报<font color=\"blue\"> 周报内容 </font>请审阅" isHTML:YES];
        // 附件
        UIImage *image = [UIImage imageNamed:@"ball"];
        NSData *imageData = UIImagePNGRepresentation(image);
        [mailCon addAttachmentData:imageData mimeType:@"image/png" fileName:@"abc.png"];
        [mailCon setMailComposeDelegate:self];
        [self presentViewController:mailCon animated:YES completion:nil];
    }else{
        NSLog(@"不能发邮件");
    }
}



@end
