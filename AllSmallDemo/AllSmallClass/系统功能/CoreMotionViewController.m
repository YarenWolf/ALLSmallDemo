//
//  CoreMotionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "CoreMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface CoreMotionViewController ()
@property (nonatomic, strong) CMMotionManager *mgr;
@property (strong, nonatomic) UIImageView *ball;
@property (nonatomic, assign) CGPoint velocity;
@end
@implementation CoreMotionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.ball = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.ball.image = [UIImage imageNamed:@"ball"];
    [self.view addSubview:self.ball];
    
    // 1.创建motion管理者
    self.mgr = [[CMMotionManager alloc] init];
    // 2.判断加速计是否可用
    if (self.mgr.isAccelerometerAvailable) {
        [self.mgr startAccelerometerUpdates];
    } else {
        NSLog(@"---加速计不可用-----");
    }
    [self push];
}

//******* push *******
- (void)push{
    // 3.设置采样间隔
    self.mgr.accelerometerUpdateInterval = 1 / 30.0;
    // 4.开始采样（采集加速度数据）
    [self.mgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        // 如果在block中执行较好时的操作，queue最好不是主队列// 如果在block中要刷新UI界面，queue最好是主队列
        NSLog(@"%f %f %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
        // 1.累加速度
        // v = a * t = a1 + a2 + a3 + ...... + at
        _velocity.x += accelerometerData.acceleration.x;
        _velocity.y -= accelerometerData.acceleration.y;
        // 2.累加位移
        // s = v * t = v1 + v2 + v3 + ...... + vt
        self.ball.frame= CGRectMake(self.ball.frame.origin.x+_velocity.x, self.ball.frame.origin.y+_velocity.y, self.ball.frame.size.width, self.ball.frame.size.height);
        // 3.边界判断
        if (self.ball.frameX <= 0) { // x超出屏幕左边
            self.ball.frameX = 0;
            // 速度取反，削弱速度
            _velocity.x *= -0.5;
        }
        if (self.ball.maxX >= self.view.frameWidth) { // x超出屏幕右边
            self.ball.maxX = self.view.frameWidth;
            
            // 速度取反，削弱速度
            _velocity.x *= -0.5;
        }
        if (self.ball.frameY <= 0) { // y超出屏幕上边
            self.ball.frameY = 0;
            // 速度取反，削弱速度
            _velocity.y *= -0.5;
        }
        if (self.ball.maxY >= self.view.frameHeight) { // y超出屏幕下边
            self.ball.maxY = self.view.frameHeight;
            // 速度取反，削弱速度
            _velocity.y *= -0.5;
        }
    }];
}

@end

