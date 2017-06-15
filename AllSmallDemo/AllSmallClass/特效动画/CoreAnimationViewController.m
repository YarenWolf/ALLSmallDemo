//
//  CoreAnimationViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
#import "CoreAnimationViewController.h"
@interface CoreAnimationViewController ()
@property (strong, nonatomic) UIImageView *myImageView;
@end
@implementation CoreAnimationViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, TopHeight, 200, 300)];
    self.myImageView.image = [UIImage imageNamed:@"moren"];
    [self.view addSubview:self.myImageView];
    self.myImageView.layer.cornerRadius = 10;
    self.myImageView.layer.masksToBounds = YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.创建对象 position位置 transform变形 opacity透明度
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2.设置属性
    //起点
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.myImageView.center];
    //目标位置（终点）
    CGPoint targetPoint = CGPointMake(self.view.bounds.size.width - self.myImageView.frame.size.width/2, self.view.bounds.size.height - self.myImageView.frame.size.height/2);
    //控制点1
    CGPoint control1 = CGPointMake(self.view.bounds.size.width-self.myImageView.frame.size.width/2, self.myImageView.center.y);
    //控制点2
    CGPoint control2 = CGPointMake(self.myImageView.center.x,self.view.bounds.size.height-self.myImageView.frame.size.height/2);
    //创建路径对象属性
    [path addCurveToPoint:targetPoint controlPoint1:control1 controlPoint2:control2];
    //将路径对象，赋值给动画对象 类型转换
    moveAnimation.path = path.CGPath;
    //动画时长
    moveAnimation.duration = 2.0;
    //动画结束后删除动画对象
    moveAnimation.removedOnCompletion = YES;
    //3.添加动画对象到指定的层(哪个层需要有动画效果)
    [self.myImageView.layer addAnimation:moveAnimation forKey:nil];
    //1.创建缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    //2.设置动画属性
    scaleAnimation.duration = 2.0;
    //开始缩放的类型
    //开始状态
    // id = 结构体类型(类型转换)
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //结束时缩放类型
    //参数：x y z 缩放
    //0.1 0.1 1.0
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnimation.removedOnCompletion = YES;
    //3.添加动画对象到指定的层上
    [self.myImageView.layer addAnimation:scaleAnimation forKey:nil];
    //1.创建动画对象 透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //2.设置属性
    opacityAnimation.duration = 2.0;
    NSNumber *fromValue = [NSNumber numberWithFloat:1.0];
    NSNumber *toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.fromValue = fromValue;
    //@[] @{key:value} @1.0
    opacityAnimation.toValue = toValue;
    opacityAnimation.removedOnCompletion = YES;
    //3.将动画对象 添加到父视图的层
    [self.myImageView.layer addAnimation:opacityAnimation forKey:nil];
    
}


@end








