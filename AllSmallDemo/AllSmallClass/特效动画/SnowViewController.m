//
//  SnowViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "SnowViewController.h"
#define MAX_SIZE 10 //雪花大小
#define MAX_DURATION 10 //时长
#define MAX_OFFSET 100
@interface SnowViewController (){
    NSTimer *timer;
}
@property(nonatomic,assign)int count;
@end
@implementation SnowViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    //下雪 每隔1秒下一次
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(snowAnimat:) userInfo:nil repeats:YES];
}
-(void)snowAnimat:(NSTimer *)timer{
    self.count++;
    NSLog(@"create:%d",self.count);
    NSLog(@"view counts:%ld",[self.view.subviews count]);
    //1.创建雪花
    UIImageView *snow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow.png"]];
    snow.tag = self.count;//区分不同的视图
    //创建下雪的位置
    int width = self.view.frame.size.width;
    int x = arc4random()%width;
    //创建雪花的大小 10~20
    int size = arc4random()%MAX_SIZE+MAX_SIZE;
    snow.frame = CGRectMake(x, -20, size, size);
    //将雪花放入到父视图中
    [self.view addSubview:snow];
    //a.设置动画开始
    [UIView beginAnimations:[NSString stringWithFormat:@"%d",self.count] context:nil];
    //b.设置属性
    //时长
    [UIView setAnimationDuration:arc4random()%MAX_DURATION+2];
    //越来越快
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //c.动画结束
    //雪花落地的位置 偏屏幕上面一点
    int offset = arc4random()%MAX_OFFSET - 50;
    snow.center = CGPointMake(snow.center.x+offset, self.view.bounds.size.height-30);
    //动画之后 设置委托 早期语法没有协议
    [UIView setAnimationDelegate:self];
    //动画结束之后发送消息
    [UIView setAnimationDidStopSelector:@selector(snowDisappear:)];
    //提交动画
    [UIView commitAnimations];
}
//区分不同的雪花动画
#define DISAPPEAR_DURATION 2 //雪花融化的时长
-(void)snowDisappear:(NSString *)animatedID{
    NSLog(@"动画结束 雪花:%@",animatedID);
    //创建雪花消失动画
    [UIView beginAnimations:animatedID context:nil];
    [UIView setAnimationDuration:arc4random()%DISAPPEAR_DURATION+2];//2秒~4秒
    //越来越快 融化速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //雪花消失 动画
    //得到一个视图中子视图或者本视图
    UIView *view = [self.view viewWithTag:[animatedID intValue]];
    UIImageView *imageView = (UIImageView*)view;
    imageView.alpha = 0.0f;
    //设置委托 解决动画结束后 删除父视图中的子视图
    [UIView setAnimationDelegate:self];
    //动画结束时 向被委托对象发送消息
    [UIView setAnimationDidStopSelector:@selector(snowRemove:)];
    //动画结束
    [UIView commitAnimations];
}
//动画结束后 删除视图
-(void)snowRemove:(NSString*)animatedID{
    UIView *snow = [self.view viewWithTag:[animatedID intValue]];
    //转换动画标识 刚好与 视图标识相符合
    NSLog(@"remove:%d",[animatedID intValue]);
    //查看view视图中 有多少子视图
    NSLog(@"Remove before view counts:%ld",[self.view.subviews count]);
    //将某个视图从父视图删除
    [snow removeFromSuperview];
    NSLog(@"Remove after view counts:%ld",[self.view.subviews count]);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

@end






