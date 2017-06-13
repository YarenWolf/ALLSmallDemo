//
//  AppleGuideViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
#import "AppleGuideViewController.h"
#import <MapKit/MapKit.h>
@interface AppleGuideViewController ()
@property (strong, nonatomic) NSString *start;
@property (strong, nonatomic) NSString *end;
@property(nonatomic, strong) CLGeocoder *geocoder;
@end
@implementation AppleGuideViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.geocoder = [[CLGeocoder alloc] init];
    _start = @"闵行";
    _end = @"徐汇";
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 2.1获取开始位置的地标
    [self.geocoder geocodeAddressString:_start completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        // 开始位置的地标
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        // 3. 获取结束位置的地标
        [self.geocoder geocodeAddressString:_end completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count == 0) return;
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            // 开始导航
            [self startNavigationWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
    }];
}
/**
 *  开始导航
 *  @param startCLPlacemark 起点的地标
 *  @param endCLPlacemark   终点的地标
 */
- (void)startNavigationWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark{
    // 0.创建起点和终点 0.1创建起点
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];;
    // 0.2创建终点
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    // 1. 设置起点和终点数组
    NSArray *items = @[startItem, endItem];
    // 2.设置启动附加参数
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    // 导航模式(驾车/走路)
    md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    // 地图显示模式
    //    md[MKLaunchOptionsMapTypeKey] = @(MKMapTypeHybrid);
    // 只要调用MKMapItem的open方法, 就可以打开系统自带的地图APP进行导航
    // Items: 告诉系统地图APP要从哪到哪
    // launchOptions: 启动系统自带地图APP的附加参数(导航的模式/是否需要先交通状况/地图的模式/..)
    [MKMapItem openMapsWithItems:items launchOptions:md];
}
@end
