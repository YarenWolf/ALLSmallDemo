//
//  GameKitBlueToothViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/4.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GameKitBlueToothViewController.h"
#import <GameKit/GameKit.h>
@interface GameKitBlueToothViewController () <GKPeerPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) GKSession *session;
@end
@implementation GameKitBlueToothViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPW)];
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)]];
    _imageView.userInteractionEnabled = YES;
    UIButton *build = [[UIButton alloc]initWithFrame:CGRectMake(10, YH(_imageView)+10, APPW-20, 30)];
    [build setTitle:@"" forState:UIControlStateNormal];
    [build addTarget:self action:@selector(buildConnect) forControlEvents:UIControlEventTouchUpInside];
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(10, YH(build)+10, APPW-20, 30)];
    [send setTitle:@"" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    build.backgroundColor = send.backgroundColor = redcolor;
    [self.view addSubviews:_imageView,build,send,nil];
}
- (void)buildConnect {
    // 1.创建设备列表控制器
    GKPeerPickerController *ppc = [[GKPeerPickerController alloc] init];
    // 2.设置代理
    ppc.delegate = self;
    // 3.显示控制器
    [ppc show];
}
- (void)sendData {
    if (self.imageView.image == nil) return;
    // 压缩图片数据
    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    //    Pet *p = [];
    //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:p];
    // 发送数据
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}
- (void)selectImage:(UITapGestureRecognizer *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark - 监听图片选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 1.销毁图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 2.显示图片
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
}
#pragma mark - GKPeerPickerControllerDelegate
/**
 *  连接到某个设备就会调用
 *  @param peerID  设备的蓝牙ID
 *  @param session 连接会话（通过session传输和接收数据）
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    // 1.销毁显示设备的控制器
    [picker dismiss];
    // 2.保存session
    self.session = session;
    // 3.处理接收的数据(接收到蓝牙设备传输的数据时，就会调用self的receiveData:fromPeer:inSession:context:)
    [self.session setDataReceiveHandler:self withContext:nil];
}
#pragma mark - 接收到蓝牙设备传输的数据，就会调用
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context{
    self.imageView.image = [UIImage imageWithData:data];
    // 写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
}
@end
