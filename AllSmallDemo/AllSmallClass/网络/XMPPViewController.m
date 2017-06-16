//
//  XMPPViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "XMPPViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface TRRecordButton : UIButton
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, weak)XMPPViewController *delegate;
@end
@implementation TRRecordButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initRecord];
    }return self;
}
-(void)beginAction{
    [self.recorder record];
}
-(void)endAction{
    
    [self.recorder stop];
    //触发发送音频的事件
    [self.delegate sendAudioWithPath:self.recorder.url.path];
}
-(void)initRecord{
    [self setTitle:@"正在录音" forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(beginAction) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    //    录音格式
    [settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //    采样率
    [settings setValue:@(11025.0) forKey:AVSampleRateKey];
    //    通道数
    [settings setValue:@(2) forKey:AVNumberOfChannelsKey];
    //    音频质量
    [settings setValue:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];
    NSString *path = @"/Users/tarena/Desktop/aaa.caf";
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
    //准备录制
    [self.recorder prepareToRecord];
}
@end
@interface TRFirendsTableViewController : UITableViewController<TRXMPPManagerDelegate,UIAlertViewDelegate>
@end
@interface TRFirendsTableViewController ()
@property (nonatomic, strong)NSMutableArray *firends;
@end
@implementation TRFirendsTableViewController
-(void)didReceiveFirendName:(NSString *)name{
    //如果有 就不添加
    if (![self.firends containsObject:name]) {
        [self.firends addObject:name];
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [[TRXMPPManager shareManager]initXMPPWithUserName:@"1409liuguobin" andPassWord:@"11111111"];
    self.firends = [NSMutableArray array];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = addItem;
    [TRXMPPManager shareManager].delegate = self;
    //    查询好友列表
    [[TRXMPPManager shareManager]queryFriends];
}
-(void)addFriend{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入好友名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *name = [alertView textFieldAtIndex:0].text;
        [[TRXMPPManager shareManager]addFriendByName:name];
        //    查询
        [[TRXMPPManager shareManager]queryFriends];
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.firends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *name = self.firends[indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [[name componentsSeparatedByString:@"@"]firstObject];
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *name = self.firends[indexPath.row];
        
        [[TRXMPPManager shareManager]deleteFriendByName:name];
        
        [self.firends removeObject:name];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *name = [[self.firends[indexPath.row] componentsSeparatedByString:@"@"]firstObject];
    XMPPViewController *vc = [[XMPPViewController alloc]init];
    vc.toName = name;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
@interface TRSecondViewController : UIViewController<TRXMPPManagerDelegate>
@end
@interface TRSecondViewController ()
@end
@implementation TRSecondViewController
-(void)didReceiveMessage:(XMPPMessage *)message{
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [TRXMPPManager shareManager].delegate = self;
}
@end
@interface XMPPViewController ()
@property (strong, nonatomic) UITextField *infoTF;
@property (strong, nonatomic) TRRecordButton *recordButton;
@property (strong, nonatomic) UITextField *toNameTF;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *messages;
@property (nonatomic, strong)AVAudioPlayer *player;
@end
@implementation XMPPViewController
- (void)clicked:(id)sender {
    UIButton *btn = sender;
    if (btn.tag==1) {//发送图片
        UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        [self.infoTF resignFirstResponder];
        XMPPMessage *message =  [[TRXMPPManager shareManager]sendMessageWithBody:self.infoTF.text andToName:self.toNameTF.text andType:@"text"];
        [self.messages addObject:message];
        [self.tableView reloadData];
        [self showLastInfo];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.infoTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 200, 20)];
    self.infoTF.text = @"124";
    self.toNameTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 130, 200, 20)];
    self.toNameTF.text = @"符合来咯";
    self.infoTF.layer.borderWidth = self.toNameTF.layer.borderWidth = 2;
    self.recordButton = [[TRRecordButton alloc]initWithFrame:CGRectMake(10, 180, 100, 20)];
    [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
    UIButton *sendPic = [[UIButton alloc]initWithFrame:CGRectMake(120, 180, 100, 20)];
    [sendPic setTitle:@"发送图片" forState:UIControlStateNormal];
    UIButton *sendMessage = [[UIButton alloc]initWithFrame:CGRectMake(250, 180, 100, 20)];
    [sendMessage setTitle:@"发送消息" forState:UIControlStateNormal];
    self.recordButton.backgroundColor = sendPic.backgroundColor = sendMessage.backgroundColor = [UIColor redColor];
    [self.recordButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendPic addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendMessage addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    sendPic.tag = 1;
    sendMessage.tag = 2;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, 300, 500) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.infoTF];
    [self.view addSubview:self.recordButton];
    [self.view addSubview:sendPic];
    [self.view addSubview:sendMessage];
    [self.view addSubview:_toNameTF];
    [self.view addSubview:self.tableView];
    
    self.messages = [NSMutableArray array];
    self.toNameTF.text = self.toName;
    TRXMPPManager *manager = [TRXMPPManager shareManager];
    //初始化xmpp
    manager.delegate = self;
    self.recordButton.delegate = self;
}
-(void)didReceiveMessage:(XMPPMessage *)message{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    NSLog(@"接收到%@说：%@",from,info);
    [self.messages addObject:message];
    [self.tableView reloadData];
    [self showLastInfo];
}
-(void)showLastInfo{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)didReceiveFirendName:(NSString *)name{
    NSLog(@"%@",name);
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    XMPPMessage *m = self.messages[indexPath.row];
    NSString *name = @"我";
    
    if (m.fromStr) {
        name = [[m.fromStr componentsSeparatedByString:@"@"]firstObject];
    }
    NSString *info = nil;
    if ([m.type isEqualToString:@"image"]) {
        info = [NSString stringWithFormat:@"%@发送了一张图片",name];
    }else if([m.type isEqualToString:@"text"]){
        info = [NSString stringWithFormat:@"%@说：%@",name,m.body];
    }else{//音频
        info = [NSString stringWithFormat:@"%@发送了音频 点击收听！",name];
    }
    cell.textLabel.text = info;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessage *m = self.messages[indexPath.row];
    if ([m.type isEqualToString:@"image"]) {
        UIViewController *vc = [[UIViewController alloc]init];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:vc.view.bounds];
        [vc.view addSubview:iv];
        [self.navigationController pushViewController:vc animated:YES];
        //显示图片
        NSString *imageString = m.body;
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:imageString options:0];
        
        iv.image = [UIImage imageWithData:imageData];
    }else if ([m.type isEqualToString:@"audio"]){
        NSData *audioData = [[NSData alloc]initWithBase64EncodedString:m.body options:0];
        self.player = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
        [self.player play];
    }
}
#pragma mark ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *url = [[info objectForKey:UIImagePickerControllerMediaURL] description];
    NSData *imageData = nil;
    if ([url hasSuffix:@"PNG"]) {
        imageData = UIImagePNGRepresentation(image);
    }else{//jpg
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    //  xmpp协议规定 发送的内容 只能是字符串
    //   nsdata 和 字符串 之间转换 base64
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    XMPPMessage *message = [[TRXMPPManager shareManager]sendMessageWithBody:imageString andToName:self.toNameTF.text andType:@"image"];
    [self.messages addObject:message];
    [self.tableView reloadData];
    [self showLastInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
-(void)sendAudioWithPath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *audioString = [data base64EncodedStringWithOptions:0];
    XMPPMessage *message = [[TRXMPPManager shareManager]sendMessageWithBody:audioString andToName:self.toNameTF.text andType:@"audio"];
    [self.messages addObject:message];
    [self.tableView reloadData];
    [self showLastInfo];
}
@end
