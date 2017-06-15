//
//  GetLocalsPlayViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GetLocalsPlayViewController.h"
#import "LocalPlayViewController.h"
@interface GetLocalsPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *musicPaths;
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation GetLocalsPlayViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.musicPaths = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 500) style:UITableViewStylePlain];
    NSString *directoryPath = @"/Users/tarena/Desktop/musics";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileNames = [fm contentsOfDirectoryAtPath:directoryPath error:nil];
    for (NSString *fileName in fileNames) {
        if ([fileName hasSuffix:@"mp3"]) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
            [self.musicPaths addObject:filePath];
        }
    }
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicPaths.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *musicPath = self.musicPaths[indexPath.row];
    cell.textLabel.text = [musicPath lastPathComponent];
    cell.textLabel.shadowColor = [UIColor redColor];
    cell.textLabel.shadowOffset = CGSizeMake(.5, .5);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LocalPlayViewController *vc = [[LocalPlayViewController alloc]init];
    vc.currentIndex = (int)indexPath.row;
    vc.musicPaths = self.musicPaths;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

