//
//  ViewController.m
//  AllSmallDemo
#import "ViewController.h"
#import "ThirdListTableView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
@interface AllSmallCell:UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *detailLabel;
-(void)setDataWithArray:(NSArray*)array;
@end
@implementation AllSmallCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, APPW-20, 20)];
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, APPW-20, 60)];
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
    NSArray *section1 = [NSArray arrayWithObjects:
  @[@"发短信",@"发短信有两种方法，一个是系统自动发，一个是调出发短信界面。",@"picture",@"SendMessageViewController"],
  @[@"远程通知",@"获取deviceToken和远程通知写在APPDelegate中的几个方法里。",@"picture",@"RemoteViewController"],
  @[@"重力效果",@"这是重力和碰撞效果方法",@"picture",@"GravityViewController"],
  @[@"旧加速计",@"这是过去的重力加速计效果Accelerometer方法",@"picture",@"AccelerometerViewController"],
  @[@"新加速计",@"这是现在的重力加速计效果CoreMotion",@"picture",@"CoreMotionViewController"],
  @[@"距离传感器",@"这是距离传感器，当距离靠近或离开的时候会触发相应方法，屏幕暗下来",@"picture",@"DistanceViewController"],
  @[@"苹果自带的社会分享",@"这是苹果自带的社会化分享功能，包括微博，facebook等",@"picture",@"AppleSocialViewController"],
  @[@"本地通知",@"这是本地通知的功能。",@"picture",@"LocalNotificationViewController"],
  @[@"发邮件",@"这是发送邮件的功能。",@"picture",@"SendEmailViewController"],
  @[@"打电话",@"这是打电话的功能。",@"picture",@"CallViewController"],
  @[@"访问通讯录",@"这是访问系统通讯录的功能。",@"picture",@"AddressBookViewController"],
  @[@"GameKit蓝牙",@"这是GameKit的蓝牙功能。",@"picture",@"GameKitViewController"],
  @[@"蓝牙4.0",@"这是CoreBlueTooth的蓝牙功能。",@"picture",@"BlueToothViewController"],
  @[@"APP跳转",@"这是跳转到其他APP并传输相应的参数。",@"picture",@"GoAPPViewController"],
 @[@"二维码",@"这是二维码功能，包括扫描和生成",@"picture",@"QRCodeViewController"],
 @[@"录音",@"这是录音功能的项目",@"picture",@"RecordAudioViewController"],
                         
                         
                         nil];
    NSArray *section2 = [NSArray arrayWithObjects:
  @[@"苹果自带导航",@"这是苹果自带的导航功能",@"picture",@"AppleGuideViewController"],
  @[@"MOB短信验证码",@"discription",@"picture",@"UIViewController"],
  @[@"百度地图",@"discription",@"picture",@"UIViewController"],
  @[@"友盟分享",@"discription",@"picture",@"UIViewController"],nil];
    
    NSArray *section3 = [NSArray arrayWithObjects:
  @[@"name",@"discription",@"picture",@"UIViewController"],
  @[@"name",@"discription",@"picture",@"UIViewController"],nil];
    
    NSArray *section4 = [NSArray arrayWithObjects:
  @[@"XML解析",@"这是XML数据格式解析",@"picture",@"XMLParseViewController"],
  @[@"name",@"discription",@"picture",@"UIViewController"],nil];
    NSArray *section5 = [NSArray arrayWithObjects:
  @[@"name",@"discription",@"picture",@"UIViewController"],
  @[@"name",@"discription",@"picture",@"UIViewController"],nil];
    NSArray *section6 = [NSArray arrayWithObjects:
  @[@"表格编辑模式",@"这是表格的编辑模式包括增删和移动",@"picture",@"EditTableViewController"],
  @[@"搜索控制器",@"这是搜索代理控制器，可以处理搜索结果",@"picture",@"SearchResaltViewController"],
  @[@"圆形集合视图",@"这是圆形的collectionView",@"picture",@"CircleCollectionViewController"],
  @[@"表情链接样式字符串",@"这是一个lable上面可容纳带有表情、链接、人员名字、跳转、拷贝等功能的字符串。",@"picture",@"EmojiViewController"],
  @[@"表格渐变出现单元格",@"向上滑动的时候单元格是渐变出现的。",@"picture",@"SlideTableViewController"],
  @[@"cell缩放的集合视图",@"集合视图的cell可以缩放",@"picture",@"ScaleCollectionViewController"],
  @[@"经典引导界面",@"这是比较经典的引导界面",@"picture",@"GuideViewController"],
  @[@"可移动的item",@"这是类似于collectionView的编辑模式，可修改、移动和删除item",@"picture",@"MoveItemViewController"],
  @[@"按钮列表弹出效果",@"这里有很多有趣的弹出菜单效果",@"picture",@"MenusViewController"],
  @[@"导航栏下拉列表",@"导航栏顶部区域筛选的下拉列表效果",@"picture",@"DownTableViewController"],
  @[@"屏幕截图",@"这是屏幕截图效果，截图之后保存到桌面",@"picture",@"ScreenshotViewController"],
  @[@"区域定位计算",@"这里包含定位，判断是否离开区域，计算行驶距离，速度，平均速度等",@"picture",@"GuidanceRegionViewController"],
nil];
    NSArray *section7 = [NSArray arrayWithObjects:
  @[@"圆形出来菜单",@"这是很好用的圆形出来的按钮，可以控制间距、大小等。",@"picture",@"RadialMenuViewController"],
  @[@"导航栏下拉菜单",@"从导航栏上面往下出现的菜单按钮",@"picture",@"NaviMenuViewController"],
  @[@"经典弹框",@"经典的自定义弹出窗口 ",@"picture",@"AlertViewController"],
  @[@"圆形出来菜单",@"圆形出来的菜单按钮，碰到边缘可自动调整布局。",@"picture",@"RadiaMenuViewController"],
  @[@"页面转场动画",@"界面布局样式修改后切换到新的界面的动画，是个枚举类型",@"picture",@"TransitionViewController"],
  @[@"动画组",@"这是几个动画效果结合在一起形成的动画",@"picture",@"AnimationsViewController"],
  @[@"有趣的欢迎界面",@"这是非常有趣的欢迎界面",@"picture",@"WelcomeViewController"],
                         nil];
    NSArray *section8 = [NSArray arrayWithObjects:
  @[@"页面转场动画",@"界面布局样式修改后切换到新的界面的动画，是个枚举类型",@"picture",@"GuideViewController"],
  @[@"name",@"discription",@"picture",@"MoveItemViewController"],nil];
    NSArray *section9 = [NSArray arrayWithObjects:
  @[@"name",@"discription",@"picture",@"UIViewController"],
  @[@"name",@"discription",@"picture",@"UIViewController"],nil];
    NSArray *section10= [NSArray arrayWithObjects:
  @[@"name",@"discription",@"picture",@"UIViewController"],
  @[@"name",@"discription",@"picture",@"UIViewController"],nil];
    self.dataArray = [NSMutableArray arrayWithObjects:
  @{@"name":@"系统功能",@"array":section1},@{@"name":@"第三方服务",@"array":section2},
  @{@"name":@"数据库处理",@"array":section3},@{@"name":@"数据解析",@"array":section4},
  @{@"name":@"网络传输",@"array":section5},@{@"name":@"UI界面设计",@"array":section6},
  @{@"name":@"特效动画",@"array":section7},@{@"name":@"aaa",@"array":section8},
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
    return 300;
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
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"gif"]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:localData];;
    imageView.frame = CGRectMake(0, 0, 200, 300);
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        NSLog(@"%@", logString);
    } logLevel:FLLogLevelWarn];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 300)];
    [view addSubview:imageView];
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
    NSArray *a = self.dataArray[indexPath.section][@"array"][indexPath.row];
    NSString *className = a[3];
    UIViewController *vc = [[NSClassFromString(className) alloc]init];
    vc.title = a[0];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
