//
//  CompassViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "CompassViewController.h"

#import <CoreLocation/CoreLocation.h>
@interface CompassViewController ()<CLLocationManagerDelegate>
@property (nonatomic ,strong) CLLocationManager *mgr;
// 指南针图片
@property (nonatomic, strong) UIImageView *compasspointer;
@end
@implementation CompassViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _mgr = [[CLLocationManager alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"compasspointer"]];
    iv.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:iv];
    self.compasspointer = iv;
    self.mgr.delegate = self;
    [self.mgr startUpdatingHeading];
}
#pragma mark - CLLocationManagerDelegate
// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    //magneticHeading 设备与磁北的相对角度  trueHeading 设置与真北的相对角度,真北始终指向地理北极点
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    self.compasspointer.transform = CGAffineTransformMakeRotation(-angle);
}

@end
