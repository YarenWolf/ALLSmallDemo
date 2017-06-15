//
//  DataDiskViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "DataDiskViewController.h"

@interface DataDiskViewController ()

@end

@implementation DataDiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *names = @[@"老杨",@"老张",@"老李"];
    //    归档 对象---》NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:names];
     [data writeToFile:@"/Users/franklin/Desktop/names" atomically:YES];
     NSData *data1 = [NSData dataWithContentsOfFile:@"/Users/franklin/Desktop/names"];
    NSArray *newNames = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    NSLog(@"%@",newNames);

}


@end
