//
//  IBeaconViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "IBeaconViewController.h"
@import CoreBluetooth;
@import CoreLocation;
// 标示当前应用程序
static NSString * const kIdentifier = @"SomeIdentifier";
// 标示蓝牙设备的 8-4-4-4-12
static NSString *const kUUID = @"00000000-0000-0000-0000-000000000000";
@interface IBeaconViewController ()<CLLocationManagerDelegate,CBPeripheralManagerDelegate>
// 检测-源(beacon)
@property (nonatomic,strong) CLBeaconRegion *beaconRegion;
// 管理周边设备
@property(nonatomic,strong) CBPeripheralManager *periphManager;
// 显示是否在区域内
@property (strong, nonatomic) UITextView *textView;
// 定位管理
@property (nonatomic,strong) CLLocationManager * locationManager;
@end

@implementation IBeaconViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UISegmentedControl *listen = [[UISegmentedControl alloc]initWithItems:@[@"停止监听",@"开始监听"]];
    UISegmentedControl *guangbo = [[UISegmentedControl alloc]initWithItems:@[@"停止广播",@"开始广播"]];
    UISegmentedControl *location = [[UISegmentedControl alloc]initWithItems:@[@"停止定位",@"开始定位"]];
    listen.frame = CGRectMake(10, 100, 300, 30);
    guangbo.frame = CGRectMake(10, 150, 300, 30);
    location.frame = CGRectMake(10, 200, 300, 30);
    [listen addTarget:self action:@selector(beginListen:) forControlEvents:UIControlEventValueChanged];
    [guangbo addTarget:self action:@selector(startAdveise:) forControlEvents:UIControlEventValueChanged];
    [location addTarget:self action:@selector(location:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:listen];
    [self.view addSubview:guangbo];
    [self.view addSubview:location];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 350, 300, 300)];
    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
}
- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}
- (CLBeaconRegion*) beaconRegion
{
    if(!_beaconRegion){
        NSUUID *proUUID = [[NSUUID alloc]initWithUUIDString:kUUID];
        _beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proUUID identifier:kIdentifier];
    }
    return _beaconRegion;
    
}
#pragma mark CoreLocationDelegate
// 当检测到周边设备时
- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    /*CLBeaconRegion 中的属性 @property (readonly, nonatomic) CLProximity proximity;
     typedef NS_ENUM(NSInteger, CLProximity) {
     CLProximityUnknown,
     CLProximityImmediate,
     CLProximityNear,
     CLProximityFar
     根据设备的远近不同 可以做不同的逻辑
     */
    NSMutableArray *arr = [beacons mutableCopy];
    NSLog(@"didRangeBeacons:%@",arr);
}
// 进入某个区域
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion");
}
// 离开某个区域
- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion");
}
// 获取当前的状态
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    switch (state) {
        case CLRegionStateInside:
            self.textView.text = @"CLRegionStateInside";
            break;
        case CLRegionStateOutside:
            self.textView.text = @"CLRegionStateOutside";
            break;
        case CLRegionStateUnknown:
            self.textView.text = @"CLRegionStateUnknown";
            break;
        default:
            break;
    }
    
}
// 源头的蓝牙设备 启动之后 会以代理方法通知我们
- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        // 向外广播
        [self  trunOnAderering];
    }
}
- (void) trunOnAderering{
    NSUUID *proximinUUID = [[NSUUID alloc]initWithUUIDString:kUUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc]initWithProximityUUID:proximinUUID identifier:kIdentifier];
    NSDictionary *data = [region peripheralDataWithMeasuredPower:nil];
    [self.periphManager startAdvertising:data];
    NSLog(@"trunONAdvertising");
}

// 开始监听 和停止监听
- (void)beginListen:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.locationManager stopMonitoringForRegion:self.beaconRegion];
            break;
        case 1:
            [self.locationManager startMonitoringForRegion:self.beaconRegion];
        default:
            break;
    }
}

// 开始广播  停止广播
- (void)startAdveise:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex ==0) {
        [self.periphManager stopAdvertising];
    }else{
        _periphManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
}

// 开始定位  停止定位
- (void)location:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }else{
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}
@end
