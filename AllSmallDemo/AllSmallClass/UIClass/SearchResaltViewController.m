//
//  SearchResaltViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
#import "SearchResaltViewController.h"
typedef NS_ENUM(NSInteger,ProductType){
    ProductTypeDevice,
    ProductTypeSoftware,
    ProductTypeOther
};
@interface Product : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic)ProductType type;
+(NSArray *)demoData;
@end
@implementation Product
+(NSArray *)demoData{
    Product *p1 = [[Product alloc]init];p1.name = @"iPhone6S";p1.type = ProductTypeDevice;
    Product *p2 = [[Product alloc]init];p2.name = @"iPhone6S Plus";p2.type = ProductTypeDevice;
    Product *p3 = [[Product alloc]init];p3.name = @"OS X EI Captain";p3.type = ProductTypeSoftware;
    Product *p4 = [[Product alloc]init];p4.name = @"Airport Time Capsule";p4.type = ProductTypeOther;
    return @[p1,p2,p3,p4];
}
@end
@interface ShowResultTableViewController : UITableViewController
@property(nonatomic,strong)NSArray *resultData;
@end
@interface ShowResultTableViewController ()
@end
@implementation ShowResultTableViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    // 找到某一个商品，然后显示商品名到cell中
    Product *p = self.resultData[indexPath.row];
    cell.textLabel.text = p.name;
    return cell;
}
@end
@interface SearchResaltViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating,UISearchBarDelegate>
@property(nonatomic,strong)NSArray *allProducts;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)ShowResultTableViewController *showResultVC;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation SearchResaltViewController
- (NSArray *)allProducts{
    if (!_allProducts) {
        _allProducts = [Product demoData];
    }return _allProducts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 350, 700) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // 创建用于显示搜索结果的表vc实例
    self.showResultVC = [[ShowResultTableViewController alloc]init];
    // 创建搜索控制器的实例,同时指定showResultVC为显示结果的vc
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.showResultVC];
    // 设置搜索控制器中的searchBar尺寸为自适应
    [self.searchController.searchBar sizeToFit];
    // 设置搜索条中的类别选项按钮
    //    self.searchController.searchBar.scopeButtonTitles = @[@"设备",@"软件",@"其它"];
    // 设置主控制器的表头视图为searchBar
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //是否允许当前界面切换一个新的视图来展示数据
    self.definesPresentationContext = YES;
    // 设置搜索控制器的结果更新代理
    // 即：当用户有了输入变化时，搜索控制器会捕获到
    // 并且给代理发消息，告知数据的变化
    self.searchController.searchResultsUpdater = self;
    // 为了当用户选择不同的类别按钮时，依然让代理
    // 知道这个变化，所以设置SearchBar的代理
    self.searchController.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma  mark - UISearchBarDelegate协议
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}
#pragma  mark - UISearchResultsUpdating协议
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //获取用户输入的搜索文本
    NSString *searchText = searchController.searchBar.text;
    //获取用户选择的类别
    NSInteger selectedButtonIndex = searchController.searchBar.selectedScopeButtonIndex;
    //声明一个用于保存匹配比对后，数据一致的商品数组
    NSMutableArray *resultArray = [NSMutableArray array];
    //遍历所有商品，依次比对商品名中是否包含输入的文本
    //及类别是否一致
    for (Product *p in self.allProducts) {
        //range.length;
        //range.location
        //@"abcdefg"-->@"def"
        //length:3  location:3
        NSRange range = [p.name rangeOfString:searchText];
        if (range.length >0 && p.type==selectedButtonIndex) {
            //比对成功，记录到resultArray中
            [resultArray addObject:p];
        }
    }
    //将要显示的数据结果给showResultVC传过去
    self.showResultVC.resultData = resultArray;
    //更新表视图显示
    [self.showResultVC.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allProducts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Product *p = self.allProducts[indexPath.row];
    cell.textLabel.text =p.name;
    return cell;
}
@end

