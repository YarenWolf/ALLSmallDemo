//
//  TopHUDViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "TopHUDViewController.h"

@interface TopHUDViewController (){
    UILabel *_msgLab;
}
@end

@implementation TopHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_msgLab) {
        return;
    }
    _msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -64, APPW, 64)];
    _msgLab.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    _msgLab.text = @"测试从顶部出来的提示";
    _msgLab.textColor = [UIColor whiteColor];
    _msgLab.font = [UIFont boldSystemFontOfSize:18];
    _msgLab.textAlignment = NSTextAlignmentCenter;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_msgLab];
    [UIView animateWithDuration:0.2 animations:^{
        _msgLab.frameY=0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_msgLab removeFromSuperview];
        _msgLab = nil;
    });
}

@end
