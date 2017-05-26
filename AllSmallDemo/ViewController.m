//
//  ViewController.m
//  AllSmallDemo
#import "ViewController.h"
#import "ThirdListTableView.h"
@interface AllSmallCell:UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *detailLabel;
-(void)setDataWithArray:(NSArray*)array;
@end
@implementation AllSmallCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 60)];
        self.detailLabel.numberOfLines = 0;
        [self addSubview:self.nameLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}
-(void)setDataWithArray:(NSArray*)array{
    self.nameLabel.text = array[0];
    self.detailLabel.text = array[1];
}
@end
@interface ViewController ()<ThirdListTableViewDelegate>
@property (nonatomic, strong) ThirdListTableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation ViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"小功能集合";
    self.dataArray = [NSMutableArray arrayWithCapacity:5];
    NSArray *section1 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section2 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section3 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section4 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section5 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section6 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section7 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section8 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section9 = [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    NSArray *section10= [NSArray arrayWithObjects:@[@"name",@"discription",@"picture"],@[@"name",@"discription",@"picture"],nil];
    self.dataArray = [NSMutableArray arrayWithObjects:
  @{@"name":@"aaa",@"array":section1},@{@"name":@"aaa",@"array":section2},
  @{@"name":@"aaa",@"array":section3},@{@"name":@"aaa",@"array":section4},
  @{@"name":@"aaa",@"array":section5},@{@"name":@"aaa",@"array":section6},
  @{@"name":@"aaa",@"array":section7},@{@"name":@"aaa",@"array":section8},
  @{@"name":@"aaa",@"array":section9},@{@"name":@"aaa",@"array":section10}, nil];
    self.mTableView = [[ThirdListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.mTableView.delegate = self;
    [self.view addSubview:self.mTableView];
}
#pragma mark - TQTableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(ThirdListTableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)mTableView:(ThirdListTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section][@"array"];
    return array.count;
}
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)mTableView:(ThirdListTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UIView *)mTableView:(ThirdListTableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * control = [[UIView alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 48, tableView.frame.size.width, 2)];
    view.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    label.text = self.dataArray[section][@"name"];
    [control addSubview:label];
    [control addSubview:view];
    return control;
}
- (UITableViewCell *)mTableView:(ThirdListTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *array = self.dataArray[indexPath.section][@"array"];
    if (cell == nil){
        cell = [[AllSmallCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    [cell setDataWithArray:array[indexPath.row]];
    return cell;
}
- (UIView *)mTableView:(ThirdListTableView *)tableView openCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 100)];
    view.backgroundColor = [UIColor redColor];
    return view;
}
///FIXME: Table view delegate
//header点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectHeaderAtSection:(NSInteger)section{
    NSLog(@"headerClick%ld",section);
}
//header展开
- (void)mTableView:(ThirdListTableView *)tableView willOpenHeaderAtSection:(NSInteger)section{
    NSLog(@"headerOpen%ld",section);
}
//celll点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellClick%@",indexPath);
}
//cell展开
- (void)mTableView:(ThirdListTableView *)tableView willOpenCellAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"OpenCell%@",indexPath);
}
//header关闭
- (void)mTableView:(ThirdListTableView *)tableView willCloseHeaderAtSection:(NSInteger)section{
    NSLog(@"headerClose%ld",section);
}
//cell关闭
- (void)mTableView:(ThirdListTableView *)tableView willCloseCellAtIndexPath:(NSIndexPath *)indexPath;{
    NSLog(@"CloseCell%@",indexPath);
}
//celll详情点击
- (void)mTableView:(ThirdListTableView *)tableView didSelectOpenCellAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了详情的cell：%@",indexPath);
}
@end
