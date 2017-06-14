//
//  AccelerometerViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AccelerometerViewController.h"

@interface AccelerometerViewController ()<UIAccelerometerDelegate>
@property (strong, nonatomic) UIImageView *ball;
@property (nonatomic, assign) CGPoint velocity;
@end
@implementation AccelerometerViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.ball = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.ball.image = [UIImage imageNamed:@"ball"];
    [self.view addSubview:self.ball];
    // 1.获得单例对象（过期：不再更新，并不一定代表不能用）
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    // 2.设置代理
    accelerometer.delegate = self;
    // 3.设置采样间隔（每隔多少秒采样一次数据）
    accelerometer.updateInterval = 1 / 30.0;
}
#pragma mark - UIAccelerometerDelegate
/**
 *  当采样到加速计数据时，就会调用一次（调用频率一般比较高）
 */
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    // 1.累加速度
    // v = a * t = a1 + a2 + a3 + ...... + at
    _velocity.x += acceleration.x;
    _velocity.y -= acceleration.y;
    // 2.累加位移
    // s = v * t = v1 + v2 + v3 + ...... + vt
    self.ball.frameX += _velocity.x;
    self.ball.frameY += _velocity.y;
    // 3.边界判断
    if (self.ball.frameX <= 0) { // x超出屏幕左边
        self.ball.frameX = 0;
        // 速度取反，削弱速度
        _velocity.x *= -0.5;
    }
    if (CGRectGetMaxX(self.ball.frame) >= self.view.frameWidth) { // x超出屏幕右边
        self.ball.frameX = self.view.frameWidth - self.ball.frameWidth;
        // 速度取反，削弱速度
        _velocity.x *= -0.5;
    }
    if (self.ball.frameY <= 0) { // y超出屏幕上边
        self.ball.frameY = 0;
        // 速度取反，削弱速度
        _velocity.y *= -0.5;
    }
    if (CGRectGetMaxY(self.ball.frame) >= self.view.frameHeight) { // y超出屏幕下边
        self.ball.frameY = self.view.frameHeight - self.ball.frameHeight;
        // 速度取反，削弱速度
        _velocity.y *= -0.5;
    }
}
@end

