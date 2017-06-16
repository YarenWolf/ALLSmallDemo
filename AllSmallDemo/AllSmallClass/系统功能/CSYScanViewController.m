//
//  CSYScanViewController.m
//  QR
//
//  Created by im on 16/6/23.
//  Copyright © 2016年 广东骆驼服饰有限公司. All rights reserved.
//

#import "CSYScanViewController.h"
@interface QRScanView ()

@property (nonatomic, assign) CGRect scanRect;

@end

@implementation QRScanView

- (instancetype)initWithScanRect:(CGRect)rect {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _scanRect = rect;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
    
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.bounds);
    
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, self.scanRect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
    CGPathRelease(path);
}

@end

@interface CSYScanViewController ()<UIPickerViewDelegate,UIImagePickerControllerDelegate>


@property (nonatomic, assign) BOOL isQRCodeCaptured;
@end

@implementation CSYScanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册获取" style:UIBarButtonItemStyleDone target:self action:@selector(abumGetCode:)];
    
     AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
     // 判断是否得到权限
     
     switch (authorizationStatus) {
     case AVAuthorizationStatusNotDetermined:
     {
     [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
     
     if (granted) {
     
     NSLog(@"ok");
     [self setpCapture];
     }
     else
     {
     NSLog(@"访问权限");
     }
     }];
     }
     break;
     case AVAuthorizationStatusAuthorized:
     {
     [self setpCapture];
     }
     break;
     case AVAuthorizationStatusRestricted:
     case AVAuthorizationStatusDenied:
     {
     NSLog(@"访问权限");
     }
     break;
     default:
     break;
     }
     

}





-(void)setpCapture
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        扫码的代码
        AVCaptureSession * session = [AVCaptureSession new];
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 入口
        NSError * error;
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (input) {
            
            [session addInput:input];
            
            
            // 输出
            AVCaptureMetadataOutput * metaOutput = [[AVCaptureMetadataOutput alloc]init];
            [metaOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [session addOutput:metaOutput];
            metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            AVCaptureVideoPreviewLayer * previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
            previewLayer.frame = self.view.frame;
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.view.layer insertSublayer:previewLayer atIndex:0];
            
            // __weak typeof(self) weakSelf = self;
            
            [[NSNotificationCenter defaultCenter]addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
                //设置扫描的窗口大小及位置（不设置将全屏扫描）
                metaOutput.rectOfInterest = [previewLayer metadataOutputRectOfInterestForRect:CGRectMake(100, 100, 200, 200)];
            }];
            
            
            QRScanView * QRScan = [[QRScanView alloc]initWithScanRect:CGRectMake(100, 100, 200, 200)];
            [self.view addSubview:QRScan];
            [session startRunning];
            
        }
        else
        {
            NSLog(@"%@",error);
        }
    });
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject * metadataObj = metadataObjects.firstObject;
    if ([metadataObj.type isEqualToString:AVMetadataObjectTypeQRCode] && !_isQRCodeCaptured) {
        _isQRCodeCaptured = YES;
        [self showAlertWithMessage:metadataObj.stringValue];
        
    }
    
}
-(void)showAlertWithMessage:(NSString * )message
{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _isQRCodeCaptured = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)abumGetCode:(id)sender {
    
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy:CIDetectorAccuracyHigh }];
    CIImage *image = [[CIImage alloc] initWithImage:originalImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    if (feature) {
       [self showAlertWithMessage:feature.messageString];
       [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"没有二维码");
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end
