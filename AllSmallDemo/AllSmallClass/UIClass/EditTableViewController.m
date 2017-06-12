
//
//  EditTableViewController.m
#import "EditTableViewController.h"
@interface EditTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *allCitys;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation EditTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市列表";
    self.allCitys = [NSMutableArray arrayWithObjects:@"北京",@"上海",@"广州",@"深圳",@"阜阳", nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEditButton:)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
// 点击右侧按钮后开启编辑模式
-(void)clickEditButton:(UIBarButtonItem *)item{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    item.title = self.tableView.isEditing?@"完成":@"编辑";
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCitys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CityCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allCitys[indexPath.row];
    return cell;
}

#pragma mark - 表格的编辑功能
//问1：当前行是否可以编辑
//此方法默认返回YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return NO;
    }else{
        return YES;
    }
}

//问2：当前行是什么编辑样式
//默认返回delegate样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == (self.allCitys.count-1)) {
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
//答1：提交编辑动作后，如何响应
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //删除动作
        [self.allCitys removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }else{
        //增加动作
        [self.allCitys addObject:@"Test"];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.allCitys.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
#pragma  mark - 移动行
//问1：该行是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//答1：移动后做什么
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *city = self.allCitys[sourceIndexPath.row];
    [self.allCitys removeObjectAtIndex:sourceIndexPath.row];
    [self.allCitys insertObject:city atIndex:destinationIndexPath.row];
}

@end
