//
//  DropScaleViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "DropScaleViewController.h"
const CGFloat HMTopViewH = 350;
@interface DropScaleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *topView;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation DropScaleViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    // 设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(HMTopViewH * 0.5, 0, 0, 0);
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -HMTopViewH, 320, HMTopViewH)];
    _topView.image = [UIImage imageNamed:@"moren"];
    _topView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView insertSubview:_topView atIndex:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"cell"];
    }cell.textLabel.text = [NSString stringWithFormat:@"测试数据---%ld", indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{// 向下拽了多少距离
    CGFloat down = -(HMTopViewH * 0.5) - scrollView.contentOffset.y;
    if (down < 0) return;
    self.topView.frameHeight = HMTopViewH + down * 5;
}
@end

