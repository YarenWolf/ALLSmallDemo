//
//  TCP&UDPViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "TCP&UDPViewController.h"
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"
@interface TRGameViewController : UIViewController<AsyncSocketDelegate>
@property (nonatomic, copy)NSString *host;
-(void)success;
-(void)fail;
@end
@interface TRMouse : UIButton
@property (nonatomic, weak)TRGameViewController *delegate;
@end
@implementation TRMouse
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"3" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor redColor];
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES];
        
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)clicked{
    [self removeFromSuperview];
    //成功次数+1
    [self.delegate success];
}
- (void)countDownAction:(NSTimer *)timer{
    //老鼠被点掉的话 就把timer停止
    if (!self.superview) {
        [timer invalidate];
        return;
    }
    int time = [[self titleForState:UIControlStateNormal]intValue];
    [self setTitle:[NSString stringWithFormat:@"%d",--time] forState:UIControlStateNormal];
    if (time==0) {
        [self removeFromSuperview];
        [timer invalidate];
        [self.delegate fail];
    }
}
@end

@interface TRGameViewController ()
@property (nonatomic, strong)AsyncSocket *serverSocket;
@property (strong, nonatomic) UILabel *successLabel;
@property (strong, nonatomic) UILabel *failLabel;
@property (nonatomic, strong)AsyncSocket *clientSocket;
@property (nonatomic, strong)AsyncSocket *myNewSocket;
@end
@implementation TRGameViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.failLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 200, 30)];
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
    [self.view addSubview:self.failLabel];
    [self.view addSubview:_successLabel];
    self.title = @"等待玩家进入。。。";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回首页" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    if (self.host) {//客户端
        self.clientSocket = [[AsyncSocket alloc]initWithDelegate:self];
        [self.clientSocket connectToHost:self.host onPort:8000 error:nil];
    }else{//服务器
        self.serverSocket = [[AsyncSocket alloc]initWithDelegate:self];
        [self.serverSocket acceptOnPort:8000 error:nil];
    }
}
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    self.myNewSocket = newSocket;
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    self.title = [NSString stringWithFormat:@"已经和%@开始游戏",host];
    
    if (self.host) {
        //如果是客户端 客户端socket调用读取数据的方法
        [self.clientSocket readDataWithTimeout:-1 tag:0];
    }else{
        //如果是服务器 用连接进来的socket调用读取数据的方法
        [self.myNewSocket readDataWithTimeout:-1 tag:0];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self.view];
    NSValue *pointValue = [NSValue valueWithCGPoint:p];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pointValue];
    if (self.host) {
        [self.clientSocket writeData:data withTimeout:-1 tag:0];
    }else{
        [self.myNewSocket writeData:data withTimeout:-1 tag:0];
    }
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSValue *pointValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    CGPoint point = [pointValue CGPointValue];
    [self addMouseAtPoint:point];
    //继续读取数据
    [sock readDataWithTimeout:-1 tag:0];
}
-(void)addMouseAtPoint:(CGPoint )point{
    TRMouse *mouse = [[TRMouse alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    mouse.delegate = self;
    mouse.center = point;
    [self.view addSubview:mouse];
}
-(void)success{
    int count = self.successLabel.text.intValue;
    self.successLabel.text = [NSString stringWithFormat:@"%d",count+1];
}
-(void)fail{
    int count = self.failLabel.text.intValue;
    self.failLabel.text = [NSString stringWithFormat:@"%d",count+1];
}
-(void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

@interface TRJoinGameTableViewController : UITableViewController
@end
@interface TRJoinGameTableViewController ()
@property (nonatomic, strong)AsyncUdpSocket *myUDPSocket;
@property (nonatomic, strong)NSMutableArray *gameHosts;
@property (nonatomic, strong)UIAlertView *waitAlertView;
@end
@implementation TRJoinGameTableViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.gameHosts = [NSMutableArray array];
    self.myUDPSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    [self.myUDPSocket bindToPort:9000 error:nil];
    [self.myUDPSocket enableBroadcast:YES error:nil];
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkingGames) userInfo:nil repeats:YES];
    [self checkingGames];
}
-(void)checkingGames{
    NSData *data = [@"谁在线" dataUsingEncoding:NSUTF8StringEncoding];
    [self.myUDPSocket sendData:data toHost:@"255.255.255.255" port:9000 withTimeout:-1 tag:0];
}
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    if (![host hasPrefix:@":"]) {
        NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([info isEqualToString:@"我在线"]) {
            if (![self.gameHosts containsObject:host]) {
                [self.gameHosts addObject:host];
                [self.tableView reloadData];
            }
        }else if ([info isEqualToString:@"同意"]) {
            //            接收到主机的同意开始后 就跳转到游戏开始页面
            if (self.waitAlertView.isVisible) {
                [self.waitAlertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            [self performSegueWithIdentifier:@"gamevc" sender:host];
        }else if ([info isEqualToString:@"拒绝"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"小伙儿 人家不跟你玩儿啊！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.myUDPSocket close];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameHosts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *info = [NSString stringWithFormat:@"%@的游戏",self.gameHosts[indexPath.row]];
    cell.textLabel.text = info;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *host = self.gameHosts[indexPath.row];
    NSData *data = [@"请求开始" dataUsingEncoding:NSUTF8StringEncoding];
    [self.myUDPSocket sendData:data toHost:host port:9000 withTimeout:-1 tag:0];
    self.waitAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求已经发出，等待主机响应。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [self.waitAlertView show];
    TRGameViewController *vc = [[TRGameViewController alloc]init];
    vc.host = @"host";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
@interface TRCreateGameViewController : UIViewController<UIAlertViewDelegate>
@end
@interface TRCreateGameViewController ()
@property (nonatomic, strong)AsyncUdpSocket *myUDPSocket;
@property (nonatomic, copy)NSString *currentHost;
@end

@implementation TRCreateGameViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.myUDPSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    [self.myUDPSocket bindToPort:9000 error:nil];
    [self.myUDPSocket enableBroadcast:YES error:nil];
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
}
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    if (![host hasPrefix:@":"]) {
        NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([info isEqualToString:@"谁在线"]) {
            NSData *onlineData = [@"我在线" dataUsingEncoding:NSUTF8StringEncoding];
            
            [self.myUDPSocket sendData:onlineData toHost:host port:9000 withTimeout:-1 tag:0];
            
        }else if ([info isEqualToString:@"请求开始"]){
            
            NSString *message = [NSString stringWithFormat:@"%@请求开始游戏",host];
            self.currentHost = host;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
            [alertView show];
        }
    }
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.myUDPSocket close];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {//拒绝
        
        NSData *data = [@"拒绝" dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.myUDPSocket sendData:data toHost:self.currentHost port:9000 withTimeout:-1 tag:0];
        
    }else{//同意
        NSData *data = [@"同意" dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.myUDPSocket sendData:data toHost:self.currentHost port:9000 withTimeout:-1 tag:0];
        //        开始游戏 跳转页面
        [self.navigationController pushViewController:[[TRGameViewController alloc]init] animated:YES];
    }
}
@end

@implementation TCP_UDPViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *creat = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
    [creat setTitle:@"创建游戏" forState:UIControlStateNormal];
    UIButton *join = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 200, 30)];
    [join setTitle:@"加入游戏" forState:UIControlStateNormal];
    creat.backgroundColor = join.backgroundColor = [UIColor redColor];
    [creat addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    [join addTarget:self action:@selector(joinGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creat];
    [self.view addSubview:join];
}
-(void)createGame{
    TRCreateGameViewController *vc = [[TRCreateGameViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)joinGame{
    [self.navigationController pushViewController:[[TRJoinGameTableViewController alloc]init] animated:YES];
}
@end

