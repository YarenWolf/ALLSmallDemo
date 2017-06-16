//
//  QRCodeViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CSYScanViewController.h"
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UIImageView *qrCode;
@property (strong, nonatomic) UILongPressGestureRecognizer *longGesture;
@property (strong, nonatomic) UITextField *codeInputTxt;
@end
@implementation QRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeInputTxt = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 300, 30)];
    self.codeInputTxt.placeholder = @"在这里输入你要生成的内容";
    UIButton *scan = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, 100, 30)];
    [scan setTitle:@"扫描二维码" forState:UIControlStateNormal];
    UIButton *output = [[UIButton alloc]initWithFrame:CGRectMake(120, 150, 100, 30)];
    [output setTitle:@"生成二维码" forState:UIControlStateNormal];
    UIButton *longTap = [[UIButton alloc]initWithFrame:CGRectMake(250, 150, 100, 30)];
    [longTap setTitle:@"长按识别" forState:UIControlStateNormal];
    scan.backgroundColor = output.backgroundColor = longTap.backgroundColor = [UIColor redColor];
    [scan addTarget:self action:@selector(scanQRcode) forControlEvents:UIControlEventTouchUpInside];
    [output addTarget:self action:@selector(createCode:) forControlEvents:UIControlEventTouchUpInside];
    [longTap addTarget:self action:@selector(ScreenShot) forControlEvents:UIControlEventTouchUpInside];
    self.qrCode = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200, 300, 300)];
    self.qrCode.image = [UIImage imageNamed:@"QR"];
    [self.view addSubview:self.codeInputTxt];
    [self.view addSubview:scan];
    [self.view addSubview:output];
    [self.view addSubview:longTap];
    [self.view addSubview:self.qrCode];
    _longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
    _longGesture.numberOfTouchesRequired = 1;
    _longGesture.numberOfTapsRequired = 1;
    _longGesture.minimumPressDuration = 1;
    self.qrCode.userInteractionEnabled = YES;
    [self.qrCode addGestureRecognizer:_longGesture];
//    [self scanQRCode];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)scanQRcode{
    [self.navigationController pushViewController:[[CSYScanViewController alloc]init] animated:YES];
}


-(void)longGesture:(UILongPressGestureRecognizer *)longGesture{
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        //截屏
        [self ScreenShot];
    }
}
-(void)ScreenShot{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);     //设置截屏大小
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage * img = [[UIImage alloc]initWithData:UIImagePNGRepresentation(viewImage)];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy:CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:img.CGImage]];
    NSLog(@"%@",features);
    CIQRCodeFeature *feature = [features firstObject];
    if (feature) {
        NSLog(@"%@",feature.messageString);
    } else {
        NSLog(@"没有二维码");
    }
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
- (void)createCode:(id)sender {
    NSString * QRcodeStr = _codeInputTxt.text;
    if ([QRcodeStr isEqualToString:@""]) return;
    NSData * data = [QRcodeStr dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage * outputImage = filter.outputImage;
    CGFloat scale = CGRectGetWidth(self.qrCode.bounds);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CIImage * transformImg = [outputImage imageByApplyingTransform:transform];
    _qrCode.image = [UIImage imageWithCIImage:transformImg];
    _codeInputTxt.text = @"";
}

@end
