//
//  RealWorldViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/4.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "RealWorldViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface CameraView : UIView

@end
@interface CameraView()
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@end


@implementation CameraView

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    self.previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    
    
    
}


@end

@interface RealWorldViewController()<CLLocationManagerDelegate>{
    CLLocationManager *locationM;
    CMMotionManager *mgr;
    UIImageView *image;
    UIView *mask;
    CGFloat i;
    UIButton *chongwuBtn;
}

@end
@implementation RealWorldViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    ///初始化相机
    CameraView *cameraView = [[CameraView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:cameraView];
    mask = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mask];
    ///图像
    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    CGPoint point = image.frame.origin;
    image.frame = CGRectMake(point.x, point.y,200, 200);
    image.center = mask.center;
    [mask addSubview:image];
    
    
    // 设置名字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    nameLabel.center = CGPointMake(image.center.x,image.center.y-130);
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    nameLabel.font = [UIFont fontWithName:@"" size:20];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"皮卡丘";
    nameLabel.layer.cornerRadius = 25;
    nameLabel.clipsToBounds = YES;
    mask.userInteractionEnabled = NO;
    [mask addSubview:nameLabel];
    
    //按钮
    chongwuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    chongwuBtn.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-100);
    [chongwuBtn setImage:[UIImage imageNamed:@"11111"] forState:UIControlStateNormal];
    chongwuBtn.userInteractionEnabled = NO;
    [self.view addSubview:chongwuBtn];
    
    locationM = [[CLLocationManager alloc]init];
    locationM.delegate = self;
    [locationM startUpdatingHeading];
    //开始获得航向数据 ///开始更新 左右
    
    
    ///初始化上下
    
    [self update];
    
}

// 已经更新到用户设备朝向时调用 左右定位
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // magneticHeading : 距离磁北方向的角度
    // trueHeading : 北方
    // headingAccuracy : 如果是负数,代表当前设备定位错误
    //        if newHeading.headingAccuracy < 0 {return}
    ///角度
    CGFloat angle =  newHeading.magneticHeading;
    float x=-9 *(angle) +self.view.center.x +500;
    if(x<-200 || x>self.view.bounds.size.width+200){//防止闪烁
        mask.center = CGPointMake(x, mask.center.y);
        return;
    }
    
    // 反向旋转图片(弧度)
    [UIView animateWithDuration:0.3 animations:^{
        mask.center = CGPointMake(x, mask.center.y);
    }];
    //    NSLog(@"%lf",mask.center.x);
}
-(void)update{
    i=0;
    //----------------------------上下定位
    mgr = [[CMMotionManager alloc]init];
    ///获取加速度
    mgr.accelerometerUpdateInterval = 1/20;
    
    [mgr startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        float y = [UIScreen mainScreen].bounds.size.height/2 +([[UIScreen mainScreen]bounds].size.height-100) * accelerometerData.acceleration.z;
        if((y > i+8)||(y<i-8)){
            [UIView animateWithDuration:0.3 animations:^{
                NSLog(@"%lf,%lf",mask.center.x,y+300);
                mask.center = CGPointMake(mask.center.x, y+300);
            }];
            i=y;
        }
    }];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        chongwuBtn.center = [touch locationInView:self.view];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        chongwuBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-100);
        
    } completion:nil];
}
@end
