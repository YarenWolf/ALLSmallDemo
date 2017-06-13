//
//  GuideViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
#import "GuideViewController.h"
#import "XSportLight.h"
@interface GuideViewController ()<XSportLightDelegate>
@end
@implementation GuideViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"aa"];
    image.frame = CGRectMake(0, 0, APPW, APPH);
    [self.view addSubview:image];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    XSportLight *SportLight = [[XSportLight alloc]init];
    SportLight.messageArray = @[
                                @"这是《简书》",
                                @"点这里撰写文章",
                                @"搜索文章",
                                @"这会是StrongX的下一节课内容"
                                ];
    SportLight.rectArray = @[
                             [NSValue valueWithCGRect:CGRectMake(0,0,0,0)],
                             [NSValue valueWithCGRect:CGRectMake(APPW/2, APPH - 20, 50, 50)],
                             [NSValue valueWithCGRect:CGRectMake(APPW - 20, 42, 50, 50)],
                             [NSValue valueWithCGRect:CGRectMake(0,0,0,0)]
                             ];
    SportLight.delegate = self;
    [self presentViewController:SportLight animated:false completion:^{
    }];
}
-(void)XSportLightClicked:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}
@end
