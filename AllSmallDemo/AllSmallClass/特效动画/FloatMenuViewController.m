//
//  FloatMenuViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/19.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "FloatMenuViewController.h"


#import "BannerMenuView.h"



@interface FloatMenuViewController ()

@end

@implementation FloatMenuViewController

- (void)viewDidLoad
{
    //这里由于图片即浮标的长宽限制在75以下，不然会变形，这是图片像数的限制
    BannerMenuView *bannerMV = [[BannerMenuView alloc] initWithFrame:CGRectMake(0, 60, isIpad?75:60, isIpad?75:60) menuWidth:isIpad?300:220];
    [self.view addSubview:bannerMV];
}

@end
