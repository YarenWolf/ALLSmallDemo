//
//  BlueToothViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "BlueToothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BlueToothViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *mgr;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) CBCharacteristic *dataInteractCharacteristic;
@property (nonatomic, strong) CBCharacteristic *peripheralInfoCharacteristic;
@end
@implementation BlueToothViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.peripherals = [NSMutableArray array];
    // 2.扫描外设
#warning 通过传入一个存放服务UDID的数组进去，过滤掉一些不要的外设
    [self.mgr scanForPeripheralsWithServices:@[@"434", @"435435"] options:nil];
}
#pragma mark - CBCentralManagerDelegate
/**
 *  3.发现外围设备的时候调用
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if (![self.peripherals containsObject:peripheral]) {
        peripheral.delegate = self;
        [self.peripherals addObject:peripheral];
    }
}
/**
 *  4.点击按钮，建立连接
 */
- (void)buildConnect{
    for (CBPeripheral *peripheral in self.peripherals) {
        [self.mgr connectPeripheral:peripheral options:nil];
    }
}
/**
 *  5.连接到某个外设的时候调用
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    // 查找外设中的所有服务
#warning 通过传入一个存放服务UDID的数组进去，过滤掉一些不要的服务
    [peripheral discoverServices:@[@"434", @"435435"]];
}
/**
 *  6.跟某个外设失去连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}

#pragma mark - CBPeripheralDelegate
/**
 *  7.外设已经查找到服务
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    // 遍历所有的服务
    for (CBService *service in peripheral.services) {
        // 过滤掉不想要的服务
        if ([service.UUID isEqual:@"123"]) {
            // 找到想要的服务
            // 扫描服务下面的特征
#warning 通过传入一个存放特征UDID的数组进去，过滤掉一些不要的特征
            [peripheral discoverCharacteristics:@[@"435", @"6456"] forService:service];
        }
    }
}
/**
 *  8.找到服务上得特征
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    // 遍历所有的特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        // 过滤掉不想要的特征
        if ([characteristic.UUID isEqual:@"456"]) {
            // 找到想要的特征
            self.dataInteractCharacteristic = characteristic;
        } else if ([characteristic.UUID isEqual:@"789"]) {
            self.peripheralInfoCharacteristic = characteristic;
        }
    }
}
@end

