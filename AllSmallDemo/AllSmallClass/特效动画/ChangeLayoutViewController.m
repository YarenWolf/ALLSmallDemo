//
//  ChangeLayoutViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "ChangeLayoutViewController.h"
@interface ChangeLayoutViewController (){
    NSTimer *timer;
}
@property (nonatomic)int count;
@end
@implementation ChangeLayoutViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *layoutPath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"layout_%d",self.count++%5] ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:layoutPath];
    NSArray *views = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (int i=0; i<views.count; i++) {
        UIView *v = views[i];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:v.frame];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+5]];
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        //超出范围的内容不显示
        iv.clipsToBounds = YES;
        iv.layer.borderWidth = 1;
        [self.view addSubview:iv];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeLayout) userInfo:nil repeats:YES];
}
-(void)saveLayout{
    NSArray *subViews = self.view.subviews;
    //    因为数组中的UIView实现了NSCoding协议所以可以直接对数组进行归档
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:subViews];
    [data writeToFile:@"/Users/tarena/Desktop/layout" atomically:YES];
    NSLog(@"%@",subViews);
}
-(void)changeLayout{
    NSString *layoutPath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"layout_%d",self.count++%5] ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:layoutPath];
    NSArray *views = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (int i=0; i<views.count; i++) {
        UIView *v = views[i];
        //遍历界面中显示的每一个图片
        UIImageView *iv = self.view.subviews[i];
        //让图片的frame 和 板式数据里面的一样
        [UIView animateWithDuration:1 animations:^{
            iv.frame = v.frame;
        }];
    }
}
-(void)dealloc{
    [timer invalidate];
}
@end
