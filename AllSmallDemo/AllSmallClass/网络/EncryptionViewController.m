//
//  EncryptionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "EncryptionViewController.h"
#import "NSString+Hash.h"
@interface EncryptionViewController (){
    UILabel *name;
}
@end

@implementation EncryptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    name = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, APPW-40, 80)];
    name.numberOfLines = 0;
    name.text = @"这是加密前数据";
    [self.view addSubview:name];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    name.text = [name.text md5String];
}

@end
