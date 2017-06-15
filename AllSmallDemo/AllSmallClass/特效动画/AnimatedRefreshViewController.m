//
//  AnimatedRefreshViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AnimatedRefreshViewController.h"
#import "YALSunnyRefreshControl.h"
@interface AnimatedRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YALSunnyRefreshControl *sunnyRefreshControl;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation AnimatedRefreshViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    self.sunnyRefreshControl = [YALSunnyRefreshControl new];
    [self.sunnyRefreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.sunnyRefreshControl beginRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.sunnyRefreshControl endRefreshing];
}
-(void)refreshing{
    NSLog(@"aaa");
}

@end
