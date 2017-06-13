//
//  RadialMenuViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "RadialMenuViewController.h"

#import "CKRadialMenu.h"
@interface RadialMenuViewController ()<CKRadialMenuDelegate>

@end

@implementation RadialMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *instructions = [[UILabel alloc] init];
    instructions.text = @"Drag popup views to adjust angle and distance.";
    CGFloat height = instructions.intrinsicContentSize.height;
    CGFloat width = instructions.intrinsicContentSize.width;
    [self.view addSubview:instructions];
    instructions.frame = CGRectMake(8, self.view.frame.size.height - 8 - height, width, height);
    instructions.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
}

-(void) viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear called");
    [super viewDidAppear:animated];
    CKRadialMenu *radialView = [[CKRadialMenu alloc] initWithFrame:CGRectMake(self.view.center.x-25, self.view.frame.size.height - 120, 50, 50)];
    radialView.delegate = self;
    radialView.centerView.backgroundColor = [UIColor grayColor];
    [radialView addPopoutView:nil withIndentifier:@"ONE"];
    [radialView addPopoutView:nil withIndentifier:@"TWO"];
    [radialView addPopoutView:nil withIndentifier:@"THREE"];
    [radialView addPopoutView:nil withIndentifier:@"FOUR"];
    [self.view addSubview:radialView];
    [radialView enableDevelopmentMode];
    
}


-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
    NSLog(@"Delegate notified of press on popout \"%@\"", identifier);
    
}

@end
