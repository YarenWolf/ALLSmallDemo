//
//  GuidanceRegionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GuidanceRegionViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface GuidanceRegionViewController ()<CLLocationManagerDelegate>
@property (nonatomic ,strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLLocation *previousLocation;// 上一次的位置
@property (nonatomic, assign) CLLocationDistance  sumDistance;// 总路程
@property (nonatomic, assign) NSTimeInterval  sumTime;// 总时间
@end
@implementation GuidanceRegionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _mgr = [[CLLocationManager alloc] init];
    self.mgr.delegate = self;
    if  ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 ){
        [self.mgr requestAlwaysAuthorization];
    }
    // 创建中心点
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.058501, 116.304171);
    // c创建圆形区域, 指定区域中心点的经纬度, 以及半径
    CLCircularRegion *circular = [[CLCircularRegion alloc] initWithCenter:center radius:500 identifier:@"软件园"];
    [self.mgr startMonitoringForRegion:circular];
    // 3.开始定位
    [self.mgr startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
// 进入监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"进入监听区域时调用");
}
// 离开监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"离开监听区域时调用");
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    if (self.previousLocation != nil) {
        CLLocationDistance distance = [newLocation distanceFromLocation:self.previousLocation];
        NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.previousLocation.timestamp];
        CGFloat speed = distance / dTime;
        self.sumTime += dTime;
        self.sumDistance += distance;
        CGFloat avgSpeed = self.sumDistance / self.sumTime;
        NSLog(@"距离%f 时间%f 速度%f 平均速度%f 总路程 %f 总时间 %f", distance, dTime, speed, avgSpeed, self.sumDistance, self.sumTime);
    }
    // 纪录上一次的位置
    self.previousLocation = newLocation;
}
@end
