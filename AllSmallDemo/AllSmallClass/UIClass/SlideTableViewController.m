//
//  SlideTableViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "SlideTableViewController.h"
#import "TTUITableViewZoomController.h"
@interface TBViewController : TTUITableViewZoomController
@end
@interface TBViewController ()
@end
@implementation TBViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TBCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"aaaaa";
    }return cell;
}
@end
@interface SlideTableViewController ()
@property(strong, nonatomic) TBViewController *tableviewVC;
@end
@implementation SlideTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableviewVC = [[TBViewController alloc] initWithStyle:UITableViewStylePlain];
    self.tableviewVC.tableView.delegate = self.tableviewVC;
    self.tableviewVC.tableView.dataSource = self.tableviewVC;
    [self.view addSubview:self.tableviewVC.view];
}

@end
