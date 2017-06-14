//
//  DownTableViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
#import "DownTableViewController.h"
@interface DownTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *QYCSBtn;//区域按钮
@property(nonatomic,strong)UITableView *QYCSTableView;//区域选择
@property(nonatomic,strong)NSArray *allQYCSs;//所有区域选择数组
@property(nonatomic,assign)BOOL QYCSShow;//QYCS表是否展示
@end
@implementation DownTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.allQYCSs = @[@"北京",@"上海",@"广州",@"深圳",@"云南",@"昆明",@"江南",@"青岛",@"丽江"];
    NSString *QYCSStr = [self.allQYCSs firstObject];
    self.QYCSBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.QYCSBtn setTitleColor:redcolor forState:UIControlStateNormal];
    [self.QYCSBtn setTitle:QYCSStr forState:UIControlStateNormal];
    [self.QYCSBtn addTarget:self action:@selector(changeQYCS) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.QYCSBtn];
}
-(void)changeQYCS{
    if (self.QYCSShow == NO) {
        self.QYCSShow = YES;
        self.QYCSTableView = [[UITableView alloc]initWithFrame:CGRectMake(APPW-130,TopHeight,125,APPH-TopHeight) style:UITableViewStylePlain];
        self.QYCSTableView.delegate = self;
        self.QYCSTableView.dataSource = self;
        [self.view addSubview:self.QYCSTableView];
        //设置动画
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.fillMode = kCAFillModeForwards;
        transition.timingFunction = UIViewAnimationCurveEaseInOut;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromBottom;
        [self.QYCSTableView.layer addAnimation:transition forKey:nil];
    }else{
        [self releaseQYCSTableView];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allQYCSs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYCS"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYCS"];
    }
    cell.textLabel.text = self.allQYCSs[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.QYCSBtn setTitle:self.allQYCSs[indexPath.row] forState:UIControlStateNormal];
    [self releaseQYCSTableView];
}
-(void)releaseQYCSTableView{
    self.QYCSShow = NO;
    CGRect frame = self.QYCSTableView.frame;
    frame.origin.y = -CGRectGetMaxY(frame);
    [UITableView animateWithDuration:0.5 animations:^{
        self.QYCSTableView.frame = frame;
    } completion:^(BOOL finished) {
        [self.QYCSTableView.layer removeAllAnimations];
        [self.QYCSTableView removeFromSuperview];
        self.QYCSTableView = nil;
    }];
}


@end
