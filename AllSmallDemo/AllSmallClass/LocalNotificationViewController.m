//
//  LocalNotificationViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "LocalNotificationViewController.h"

@interface LocalNotificationViewController ()

@end

@implementation LocalNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s", __func__);
    // 1.创建本地通知对象
    UILocalNotification *note = [[UILocalNotification alloc] init];
    // 指定通知发送的时间(指定5秒之后发送通知)
    note.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    // 注意: 在真实开发中一般情况下还需要指定时区(让通知的时间跟随当前时区)
    note.timeZone = [NSTimeZone defaultTimeZone];
    // 指定通知内容
    note.alertBody = @"这是通知内容";
    // 设置通知重复的周期(1分钟通知一期)
    //    note.repeatInterval = kCFCalendarUnitSecond;
    // 指定锁屏界面的信息
    note.alertAction = @"这是锁屏界面的信息";
    // 设置点击通知进入程序时候的启动图片
    note.alertLaunchImage = @"Default";
    // 收到通知播放的音乐
    note.soundName = @"buyao.wav";
    // 设置应用程序的提醒图标
    note.applicationIconBadgeNumber = 998;
    // 注册通知时可以指定将来点击通知之后需要传递的数据
    note.userInfo = @{@"name":@"lnj",
                      @"age":@"28",
                      @"phone": @"12345678912"};
    // 2.注册通知(图片的名称建议使用应用程序启动的图片名称)
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (void)removeNote {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
