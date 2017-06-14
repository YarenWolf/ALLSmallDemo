//
//  JourneyViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "JourneyViewController.h"
#import "JourneyView.h"
@interface JourneyViewController (){
    UIScrollView *scrollView;
    JourneyView *myView;
}
@end

@implementation JourneyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    myView=[[JourneyView alloc]init];
    MsgModel * model=[[MsgModel alloc]init];
    model.address=@"杭州师范大学";
    model.motive=@"图书馆还书";
    model.date=@"2015.07.15 12:20:10";
    model.color=[UIColor redColor];
    myView.msgModelArray=@[model,model,model,model,model,model,model,model,model,model,model,model];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    scrollView.backgroundColor=RGBACOLOR(240, 240, 240, 1);
    myView.frame=CGRectMake(0,SP_W(65), APPW, SP_W(60)*myView.msgModelArray.count+65);
    scrollView.contentSize=CGSizeMake(0, SP_W(60)*(myView.msgModelArray.count+2)+SP_W(30));
    [scrollView addSubview:myView];
    [self.view addSubview:scrollView];
}

@end
