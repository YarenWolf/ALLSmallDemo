//
//  SocketViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
#import "SocketViewController.h"
@interface SocketViewController ()
@property (strong, nonatomic) UITextField *hostTF;
@property (nonatomic, strong)NSMutableData *allData;
@property (nonatomic, copy)NSString *host;
@property (nonatomic)int fileLength;
@property (nonatomic, copy)NSString *fileName;
@end

@implementation SocketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hostTF = [[UITextField alloc]initWithFrame:CGRectMake(10, TopHeight, APPW-20, 30)];
    self.hostTF.backgroundColor = redcolor;
    self.hostTF.placeholder = @"填写域名";
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(10, 2*TopHeight, 200, 30)];
    send.backgroundColor = redcolor;
    [send setTitle:@"连接" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubviews:self.hostTF,send,nil];
    self.allData = [NSMutableData data];
    self.serverSocket = [[AsyncSocket alloc]initWithDelegate:self];
    [self.serverSocket acceptOnPort:8000 error:nil];
}
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    self.myNewSocket = newSocket;
}
- (void)clicked:(id)sender {
    self.clientSocket = [[AsyncSocket alloc]initWithDelegate:self];
    
    [self.clientSocket connectToHost:self.hostTF.text onPort:8000 error:nil];
    //发送文件
    //    NSString *path = [[NSBundle mainBundle]pathForResource:@"0" ofType:@"jpg"];
    //    101010101111001010101101011010101011101010101010101001010100101010100101010101001010101010100101010100101011010101010011010101010100100100101010010101001010010100101001010101010011001110010110101010101001011010101010
    //    abc.mp3&&124134123
    //
    NSString *path = @"/Users/tarena/Desktop/musics/小苹果.mp3";
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSString *headerString = [NSString stringWithFormat:@"%@&&%d",[path lastPathComponent],fileData.length];
    NSData *headerData =[headerString dataUsingEncoding:NSUTF8StringEncoding];
    //    把headerData装进100个字节的data里面
    NSMutableData *sendAllData = [NSMutableData dataWithLength:100];
    [sendAllData replaceBytesInRange:NSMakeRange(0, headerData.length) withBytes:headerData.bytes];
    //    把文件数据拼接在头的后面
    [sendAllData appendData:fileData];
    [self.clientSocket writeData:sendAllData withTimeout:-1 tag:0];
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    self.host = host;
    [self.myNewSocket readDataWithTimeout:-1 tag:0];
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //    取到前100个字节
    NSData *headerData = [data subdataWithRange:NSMakeRange(0, 100)];
    //    abc  utf-8
    //    010101 101010 10101
    //    1010101011001100110
    NSString *headerString = [[NSString alloc]initWithData:headerData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",headerString);
    //    如果100个字节能转成字符串 并且此字符串 用两个&&符号分割正好为2部分的话说明这是第一部分数据 包含消息头
    if (headerString&& [headerString componentsSeparatedByString:@"&&"].count == 2) {//说明有头 是第一部分数据
        //把头里面的数据取出来
        NSArray *headers = [headerString componentsSeparatedByString:@"&&"];
        self.fileName  = headers[0];
        self.fileLength = [headers[1]intValue];
        //        把抛去头剩下的文件数据取出来保存
        NSData *subFileData = [data subdataWithRange:NSMakeRange(100, data.length-100)];
        self.allData = [NSMutableData data];
        [self.allData appendData:subFileData];
    }else{//不是第一部分 此时的data 里面都是文件数据
        [self.allData appendData:data];
    }
    //判断是否传输完成
    if (self.allData.length == self.fileLength) {
        NSString *newPath = [@"/Users/tarena/Desktop/" stringByAppendingPathComponent:self.fileName];
        [self.allData writeToFile:newPath atomically:YES];
    }
    //    持续接收数据 保证后面的数据能够接收到
    [sock readDataWithTimeout:-1 tag:0];
    
}
@end
