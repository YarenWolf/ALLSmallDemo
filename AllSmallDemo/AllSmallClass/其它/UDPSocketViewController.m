//
//  UDPSocketViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "UDPSocketViewController.h"
#import "AsyncUdpSocket.h"
@interface UDPSocketViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AsyncUdpSocket *myUDPSocket;
@property (nonatomic, strong)NSMutableArray *onlineHosts;
@property (nonatomic, copy)NSString *toHost;

@property (strong, nonatomic) UITextView *historyTV;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISwitch *mySwitch;
@property (strong, nonatomic) UITextField *sendInfoTF;

@end
@implementation UDPSocketViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.sendInfoTF = [[UITextField alloc]initWithFrame:CGRectMake(10, TopHeight, APPW-20, 30)];
    self.sendInfoTF.layer.borderColor = [UIColor redColor].CGColor;
    self.sendInfoTF.layer.borderWidth = 2;
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(10, 110, 150, 30)];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    send.backgroundColor = [UIColor redColor];
    [send addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 200, 20)];
    self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(230, 150, 100, 20)];
    [self.mySwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    self.historyTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 200, 200, 300)];
    self.historyTV.backgroundColor = [UIColor grayColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(220, 200, 200, 300) style:UITableViewStylePlain];
    self.tableView.backgroundColor = redcolor;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.sendInfoTF];
    [self.view addSubview:send];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:_mySwitch];
    [self.view addSubview:_historyTV];
    [self.view addSubview:self.tableView];
    self.toHost = @"255.255.255.255";
    self.onlineHosts = [NSMutableArray array];
    self.myUDPSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    //    绑定端口
    [self.myUDPSocket bindToPort:9000 error:nil];
    //    开启广播模式
    [self.myUDPSocket enableBroadcast:YES error:nil];
    //    接收数据
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
    [self checkingOnline];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkingOnline) userInfo:nil repeats:YES];
}
-(void)checkingOnline{
    NSData *data = [@"谁在线" dataUsingEncoding:NSUTF8StringEncoding];
    //    给网段内所有的人发送消息 四个255表示广播地址
    [self.myUDPSocket sendData:data toHost:@"255.255.255.255" port:9000 withTimeout:-1 tag:0];
}
- (IBAction)sendAction:(id)sender {
    NSData *data = [self.sendInfoTF.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.myUDPSocket sendData:data toHost:self.toHost port:9000 withTimeout:-1 tag:0];
    
    NSString *info = self.toHost;
    if ([self.toHost isEqualToString:@"255.255.255.255"]) {
        info = @"所有人";
    }
    self.historyTV.text = [self.historyTV.text stringByAppendingFormat:@"\n我对%@说：%@",info,self.sendInfoTF.text];
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    //   把ipV6的消息过滤掉
    if (![host hasPrefix:@":"]) {
        NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([info isEqualToString:@"谁在线"]) {
            NSData *data = [@"我在线" dataUsingEncoding:NSUTF8StringEncoding];
            [self.myUDPSocket sendData:data toHost:host port:9000 withTimeout:-1 tag:0];
        }else if ([info isEqualToString:@"我在线"]){
            if (![self.onlineHosts containsObject:host]) {
                [self.onlineHosts addObject:host];
                [self.tableView reloadData];
            }
        }else{//代表接收到的是消息内容
            self.historyTV.text = [self.historyTV.text stringByAppendingFormat:@"\n%@说：%@",host,info];
        }
    }
    [self.myUDPSocket receiveWithTimeout:-1 tag:0];
    return YES;
}
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.onlineHosts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *host = self.onlineHosts[indexPath.row];
    cell.textLabel.text = [[host componentsSeparatedByString:@"."] lastObject];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.toHost = self.onlineHosts[indexPath.row];
    [self.mySwitch setOn:NO animated:YES];
    self.statusLabel.text = [NSString stringWithFormat:@"对%@说",self.toHost];
}
- (IBAction)valueChange:(id)sender {
    if (self.mySwitch.isOn) {
        self.statusLabel.text = @"对所有人说：";
        self.toHost = @"255.255.255.255";
    }else{
        [self.mySwitch setOn:YES animated:YES];
    }
}
@end
