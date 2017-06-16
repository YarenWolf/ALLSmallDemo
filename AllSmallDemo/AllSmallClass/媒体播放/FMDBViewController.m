//
//  FMDBViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"
@interface ContactModel : NSObject

@property (nonatomic,assign) NSInteger pid;
@property (nonatomic,copy) NSString *cname;
@property (nonatomic,copy) NSString *cphoneNumber;

@end
@implementation ContactModel

@end

@interface DBManager : NSObject

+(id)manager;

-(void)insertModel:(ContactModel *)model;

-(void)deleteModel:(ContactModel *)model;

-(void)updateModel:(ContactModel *)model;

-(NSMutableArray *)fetchAllModel;

-(NSMutableArray *)searchWithKey:(NSString *)key;


@end
@implementation DBManager
{
    FMDatabase *_fmdb;
}

+(id)manager
{
    static DBManager *_m = nil;
    if (!_m) {
        _m = [[DBManager alloc]init];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //指定数据库文件的位置
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"mynew1.db"];
        _fmdb = [[FMDatabase alloc]initWithPath:path];
        NSLog(@"%@",path);
        //open,如果数据库文件不存在,则创建一个,如果已经存在,则打开数据库并备用
        if ([_fmdb open]) {
            //数据库打开成功,创建数据库表
            NSString *sql = @"create table if not exists person(pid integer primary key autoincrement,pname varchar(64),pnumber varchar(32),pheader blob)";
            [_fmdb executeUpdate:sql];
        }
        else
        {
            NSLog(@"创建/打开数据库失败");
        }
        
    }
    return self;
}

-(void)insertModel:(ContactModel *)model
{
    //为了防止sql注入
    
    NSString *sql = @"insert into person(pname,pnumber) values (?,?)";
    BOOL success = [_fmdb executeUpdate:sql,model.cname,model.cphoneNumber];
    
    //    NSString *sql = [NSString stringWithFormat:@"insert into person(pname,pnumber) values ('%@','%@')",model.cname,model.cphoneNumber];
    //    BOOL success = [_fmdb executeUpdate:sql];
    
    NSLog(@"%@",sql);
    if (success) {
        NSLog(@"新增数据成功");
    }
    else
    {
        NSLog(@"新增数据失败");
    }
}

-(void)deleteModel:(ContactModel *)model
{
    NSString *sql = @"delete from person where pid = ?";
    [_fmdb executeUpdate:sql,@(model.pid)];
}

-(void)updateModel:(ContactModel *)model
{
    NSString *sql = @"update person set pname=?, pnumber=? where pid=?";
    [_fmdb executeUpdate:sql,model.cname,model.cphoneNumber,@(model.pid)];
}

-(NSMutableArray *)fetchAllModel
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *sql = @"select * from person";
    FMResultSet *result = [_fmdb executeQuery:sql];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"pname"];
        NSString *phone = [result stringForColumn:@"pnumber"];
        ContactModel *model = [[ContactModel alloc]init];
        model.pid = [result intForColumn:@"pid"];
        model.cname = name;
        model.cphoneNumber = phone;
        [arr addObject:model];
    }
    return arr;
}

-(NSMutableArray *)searchWithKey:(NSString *)key
{
    return nil;
}
@end

@interface AddEditViewController : UIViewController

@property (nonatomic,strong) ContactModel *model;

@property (nonatomic,copy) void(^callback)();

@end

@interface AddEditViewController ()
{
    BOOL _isEditing;
}
@property (strong, nonatomic) UITextField *nameLabel;
@property (strong, nonatomic) UITextField *phoneLabel;


@end

@implementation AddEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = whitecolor;
    _isEditing = (BOOL)_model;
    self.nameLabel = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, APPW-20, 30)];
    self.phoneLabel = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, APPW-20, 30)];
    self.nameLabel.layer.borderWidth = self.phoneLabel.layer.borderWidth = 1;
    self.nameLabel.placeholder = @"请输入姓名";
    self.phoneLabel.placeholder = @"请输入手机号";
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneLabel];
    self.title = _isEditing?@"编辑":@"新增";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    _nameLabel.text = _model.cname;
    _phoneLabel.text = _model.cphoneNumber;
    
}

-(void)doneAction
{
    NSString *username = _nameLabel.text;
    NSString *phone = _phoneLabel.text;
    
    _model = _isEditing?_model:[[ContactModel alloc]init];
    _model.cname = username;
    _model.cphoneNumber = phone;
    if (_isEditing) {
        [[DBManager manager]updateModel:_model];
    }
    else
    {
        [[DBManager manager]insertModel:_model];
    }
    if (_callback) {
        _callback();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end

@interface FMDBViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation FMDBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareData];
    [self uiConfig];
    
}

-(void)prepareData
{
    _dataArray = [[DBManager manager]fetchAllModel];
    
}
-(void)uiConfig
{
    self.title = @"通讯录";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
}

-(void)refresh
{
    _dataArray = [[DBManager manager]fetchAllModel];
    [_tableView reloadData];
}

-(void)addAction
{
    AddEditViewController *vc = [[AddEditViewController alloc]init];
    [vc setCallback:^{
        [self refresh];
        //        _tableView insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = [_dataArray[indexPath.row] cname];
    cell.detailTextLabel.text = [_dataArray[indexPath.row] cphoneNumber];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddEditViewController *vc = [[AddEditViewController alloc]init];
    vc.model = _dataArray[indexPath.row];
    [vc setCallback:^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == 1 ) {
        //数据库
        [[DBManager manager]deleteModel:_dataArray[indexPath.row]];
        
        //删除数据源
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        
        //cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

@end
