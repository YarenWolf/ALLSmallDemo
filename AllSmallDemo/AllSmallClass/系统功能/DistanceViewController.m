
//
//  DistanceViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "DistanceViewController.h"

@interface DistanceViewController ()

@end

@implementation DistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  [UIApplication sharedApplication].proximitySensingEnabled = YES;
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
//  监听距离改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)proximityStateDidChange:(NSNotification *)note{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物体靠近");
    }else{
        NSLog(@"物理离开");
    }
}
@end
