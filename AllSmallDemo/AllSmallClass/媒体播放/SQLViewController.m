//
//  SQLViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "SQLViewController.h"
#import <sqlite3.h>
@interface HMShop : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@end
@implementation HMShop
@end
@interface SQLViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *priceField;
/** 数据库对象实例 */
@property (nonatomic, assign) sqlite3 *db;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shops;
@end
@implementation SQLViewController
- (NSMutableArray *)shops{
    if (!_shops) {
        self.shops = [[NSMutableArray alloc] init];
    }return _shops;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, TopHeight, APPW-20, 30)];
    self.nameField.layer.borderWidth = 1;
    self.nameField.text = @"手机";
    self.priceField = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, APPW-20, 30)];
    self.priceField.layer.borderWidth = 1;
    self.priceField.text = @"18233222399999";
    UIButton *insert = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, APPW-20, 30)];
    [insert setTitle:@"增加数据" forState:UIControlStateNormal];
    insert.backgroundColor = [UIColor redColor];
    [insert addTarget:self action:@selector(insert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.priceField];
    [self.view addSubview:insert];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 200, APPW-20, APPH-200) style:UITableViewStylePlain];
    
    // 增加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, APPW, 44);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    // 初始化数据库
    [self setupDb];
    // 查询数据
    [self setupData];
    // 关闭数据库
    //    sqlite3_close();
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.shops removeAllObjects];
    NSString *sql = [NSString stringWithFormat:@"SELECT name,price FROM t_shop WHERE name LIKE '%%%@%%' OR  price LIKE '%%%@%%' ;", searchText, searchText];
    // stmt是用来取出查询结果的
    sqlite3_stmt *stmt = NULL;
    // 准备
    int status = sqlite3_prepare_v2(self.db, sql.UTF8String, -1, &stmt, NULL);
    if (status == SQLITE_OK) { // 准备成功 -- SQL语句正确
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 成功取出一条数据
            const char *name = (const char *)sqlite3_column_text(stmt, 0);
            const char *price = (const char *)sqlite3_column_text(stmt, 1);
            HMShop *shop = [[HMShop alloc] init];
            shop.name = [NSString stringWithUTF8String:name];
            shop.price = [NSString stringWithUTF8String:price];
            [self.shops addObject:shop];
        }
    }
    [self.tableView reloadData];
}
/**
 查询数据
 */
- (void)setupData{
    const char *sql = "SELECT name,price FROM t_shop;";
    // stmt是用来取出查询结果的
    sqlite3_stmt *stmt = NULL;
    // 准备
    int status = sqlite3_prepare_v2(self.db, sql, -1, &stmt, NULL);
    if (status == SQLITE_OK) { // 准备成功 -- SQL语句正确
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 成功取出一条数据
            const char *name = (const char *)sqlite3_column_text(stmt, 0);
            const char *price = (const char *)sqlite3_column_text(stmt, 1);
            HMShop *shop = [[HMShop alloc] init];
            shop.name = [NSString stringWithUTF8String:name];
            shop.price = [NSString stringWithUTF8String:price];
            [self.shops addObject:shop];
        }
    }
}

/**
 初始化数据库
 */
- (void)setupDb{
    // 打开数据库(连接数据库)
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops.sqlite"];
    // 如果数据库文件不存在, 系统会自动创建文件自动初始化数据库
    int status = sqlite3_open(filename.UTF8String, &_db);
    if (status == SQLITE_OK) { // 打开成功
        NSLog(@"打开数据库成功");
        // 创表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, price real);";
        char *errmsg = NULL;
        sqlite3_exec(self.db, sql, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"创表失败--%s", errmsg);
        }
    } else { // 打开失败
        NSLog(@"打开数据库失败");
    }
}
- (void)insert {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_shop(name, price) VALUES ('%@', %f);", self.nameField.text, self.priceField.text.doubleValue];
    sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, NULL);
    // 刷新表格
    HMShop *shop = [[HMShop alloc] init];
    shop.name = self.nameField.text;
    shop.price = self.priceField.text;
    [self.shops addObject:shop];
    [self.tableView reloadData];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shops.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"shop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor grayColor];
    }
    HMShop *shop = self.shops[indexPath.row];
    cell.textLabel.text = shop.name;
    cell.detailTextLabel.text = shop.price;
    return cell;
}
@end

