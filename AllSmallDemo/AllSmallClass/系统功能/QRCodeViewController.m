//
//  QRCodeViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UIImageView *qrCode;
@end
@implementation QRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self scanQRCode];
}
-(void)scanQRCode{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:output];
    
    // 管道可以规定质量  流畅 高清 标清
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 设置输出流的监听类型 必须在管道连接之后设置
    output.metadataObjectTypes = @[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode];
    self.session = session;
    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:preview atIndex:100];
    self.previewLayer = preview;
    [_session startRunning];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSLog(@"扫描到的数据是:%@", obj.stringValue);
    }
}
#pragma mark 生成二维码
- (void)getQRCode{
    self.qrCode = [[UIImageView alloc]initWithFrame:CGRectMake(20, TopHeight+20, 300, 300)];
    [self.view addSubview:self.qrCode];
    NSString *str = @"二维码里面存放的信息内容";
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 2.获取数据  设置给filter
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    // 3.获取二维码
    CIImage *cimage = filter.outputImage;
    self.qrCode.image = [UIImage imageWithCIImage:cimage];
}


@end
