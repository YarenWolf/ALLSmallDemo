//
//  GameKitViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GameKitViewController.h"
/*
 > 讲解相片选择器
 *先不设置代理,创建后直接运行
 *从选择相片后需要关闭控制器引出代理
 *实现代理方法展示数据
 *PPT讲解蓝牙连接(不是所有应用都可以用蓝牙传输东西,必须相同应用事先写好如何处理. 苹果蓝牙传输非常满, 而且传输过程中没有进度)
 *在storyboard中添加按钮, 点击按钮后创建对端选择控制器, 设置代理,显示视图控制器
 *在代理方法中打印peerID, 讲解session用途查看头文件引出利用传递数据
 *定义属性保存session , 在storyboard中添加按钮监听按钮点击利用session传递图片
 *讲解传递数据方法两种模式区别
 *设置数据处理者, 讲解如何找到数据处理方法,在数据处理方法中打印LOG运行验证
 *将接收到的数据转换为图片后现实在界面上
 *总结蓝牙传输
 */
#import <GameKit/GameKit.h>
@interface GameKitViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, GKPeerPickerControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong)GKSession *session;
@end
@implementation GameKitViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300, 300)];
    UIButton *selectPhoto = [[UIButton alloc]initWithFrame:CGRectMake(10, 350, 300, 20)];
    [selectPhoto setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectPhoto addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *connect = [[UIButton alloc]initWithFrame:CGRectMake(10, 380, 300, 20)];
    [connect setTitle:@"建立连接" forState:UIControlStateNormal];
    [connect addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendData = [[UIButton alloc]initWithFrame:CGRectMake(10, 410, 300, 20)];
    [sendData setTitle:@"发送数据" forState:UIControlStateNormal];
    [sendData addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    selectPhoto.backgroundColor = connect.backgroundColor = sendData.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:selectPhoto];
    [self.view addSubview:connect];
    [self.view addSubview:sendData];
}
- (void)selectPhoto{
    // 1.判断照片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 1.1实例化控制器
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        // 1.2设置照片源
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        // 1.3设置允许修改
        picker.allowsEditing = YES;
        // 1.4设置代理
        picker.delegate = self;
        // 1.5显示控制器
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}
#pragma mark - imagePicker代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 蓝牙连接
- (void)connectBtnClick{
    // 1.创建对端选择控制器
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    [picker show];
}
// 发送相片
- (void)sendPhoto {
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    // 利用session发送相片
    //    self.session sendData:<#(NSData *)#> toPeers:<#(NSArray *)#> withDataMode:<#(GKSendDataMode)#> error:<#(NSError *__autoreleasing *)#>
    /*
     TCP协议、UDP协议
     1. 要发送的数据（二进制的）
     2. 数据发送模式
     GKSendDataReliable      ：确保数据发送成功(TCP协议，对网络压力大)
     GKSendDataUnReliable    ：只管发送不管成功(UDP协议，对数据完整性要求不高，对网络压力下)
     */
    [self.session sendDataToAllPeers:imageData withDataMode:GKSendDataReliable error:nil];
}
#pragma mark - GKPeerPickerControllerDelegate
// 完成对端连接
// GKSession对象用于表现两个蓝牙设备之间连接的一个会话，你也可以使用它在两个设备之间发送和接收数据。
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    NSLog(@"连接成功 %@", peerID);
    self.session = session;
    [self.session setDataReceiveHandler:self withContext:nil];
    [picker dismiss];
}
// 取消对端选择控制器
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    NSLog(@"取消蓝牙选择器");
}
// 数据接受处理方法，此方法需要从文档中粘贴出来，没有智能提示
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    NSLog(@"接收到数据");
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
}
@end

