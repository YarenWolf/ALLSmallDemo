//
//  TaiViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GradientViewController.h"
#import "PGScView.h"
@interface GradientViewController ()<UIScrollViewDelegate , PGScViewDelegate>{
    PGScView *_pgView;
    NSArray *labelArr;
    UIScrollView *scView;
    BOOL _isTap ;
}
@end
@implementation GradientViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    labelArr = @[@"新闻", @"军事", @"政治", @"娱乐", @"财经" , @"游戏" ,  @"健康" ,  @"视频" ,  @"时尚" ];
    //内容部分
    [self initContentScView];
    _pgView = [[PGScView alloc] initWithFrame:CGRectMake(0, 70, APPW , 50 )];
    _pgView.array = labelArr;
    _pgView.pgDelegate = self;
    [self.view addSubview:_pgView];
}
//内容部分的滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_isTap){//只有在不是点击事件中才允许走下面的方法
        _pgView.offsetX = scrollView.contentOffset.x ;
    }
    _isTap = NO;
    
//    CGFloat offset = scrollView.contentOffset.x;
//    //定义一个两个变量控制左右按钮的渐变
//    NSInteger left = offset/APPW;
//    NSInteger right = 1 + left;
//    UIButton * leftButton = self.buttons[left];
//    UIButton * rightButton = nil;
//    if (right < self.buttons.count) {
//        rightButton = self.buttons[right];
//    }
//    //切换左右按钮
//    CGFloat scaleR = offset/APPW - left;
//    CGFloat scaleL = 1 - scaleR;
//    //左右按钮的缩放比例
//    CGFloat tranScale = 1.2 - 1 ;
//    //宽和高的缩放(渐变)
//    leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
//    rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
//    //颜色的渐变
//    UIColor * rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
//    UIColor * leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
//    //重新设置颜色
//    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
//    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];

}
/**************************** 3 part ***********************************/
- (void)itemWherePage:(int)page contentName:(NSString *)contentName isTap:(BOOL)isTap{
    NSLog(@"您选中的item索引位置为=【%d】, 选中的名字为=【%@】， 是否是点击的事件(还有滑动)=【%d】", page , contentName, isTap);
    _isTap = isTap;
    if (isTap) {
        [scView setContentOffset:CGPointMake(page *APPW, 0) animated:YES];
    }
}
#pragma mark - 内容部分，非重要部分
- (void)initContentScView{
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120 , APPW, 300)];
    scView.contentSize = CGSizeMake(320*labelArr.count, scView.bounds.size.height);
    scView.pagingEnabled = YES;
    scView.delegate = self;
    for (int i=0; i<labelArr.count; i++) {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(APPW*i , 0, APPW , scView.frame.size.height)];
        myView.backgroundColor = [self randomColor];
        [scView addSubview:myView];
    }
    [self.view addSubview:scView];
}
- (UIColor *)randomColor{
    return  [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
}
@end

