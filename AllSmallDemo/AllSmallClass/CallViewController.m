//
//  CallViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "CallViewController.h"

@interface CallViewController ()

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSURL *url = [NSURL URLWithString:@"tel://18721064516"];
    [[UIApplication sharedApplication]openURL:url];
}

@end
