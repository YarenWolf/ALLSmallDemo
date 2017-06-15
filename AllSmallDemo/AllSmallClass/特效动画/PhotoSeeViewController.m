//
//  PhotoSeeViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "PhotoSeeViewController.h"
typedef NS_ENUM(NSInteger, TRPhotoStatus) {
    TRPhotoStatusNormal,
    TRPhotoStatusBig,
};
@interface TRPhoto : UIView
@property (nonatomic, strong)UIView *drawView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic)float speed;
@property (nonatomic)float oldSpeed;
@property (nonatomic)CGRect oldFrame;
@property (nonatomic)float oldAlpha;
@property (nonatomic)TRPhotoStatus status;
-(void)initStatus;
@end
@implementation TRPhoto
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}
-(void)initStatus{
    self.speed = self.alpha;
    float w = 70*self.alpha;
    float h = 100*self.alpha;
    
    self.frame = CGRectMake(-w, arc4random()%(int)(568-h), w, h);
    [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(moveAction) userInfo:nil repeats:YES];
    self.backgroundColor = [UIColor redColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.drawView = [[UIView alloc]initWithFrame:self.bounds];
    self.drawView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.drawView];
    //添加ImageView
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.imageView];
    //    添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2Action)];
    [tap2 setNumberOfTouchesRequired:2];
    [self addGestureRecognizer:tap2];
}
-(void)tap2Action{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    //    动画样式
    //    suckEffect/olgFlip/
    NSArray *animations = @[@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose",@"fade"];
    animation.type = animations[arc4random()%animations.count];
    //   动画方向
    //    `fromLeft', `fromRight', `fromTop' and
    //    * `fromBottom'. */
    animation.subtype = @"fromLeft";
    [self.layer addAnimation:animation forKey:@"abc"];
    
    [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}
-(void)tapAction{
    
    [UIView animateWithDuration:.5 animations:^{
        if (self.status==TRPhotoStatusNormal) {
            self.oldAlpha = self.alpha;
            self.oldFrame = self.frame;
            self.oldSpeed = self.speed;
            self.frame = CGRectMake(60, 134, 200, 300);
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            
            self.speed = 0;
            self.alpha = 1;
            [self.superview bringSubviewToFront:self];
            self.status = TRPhotoStatusBig;
        }else if (self.status==TRPhotoStatusBig){
            
            self.frame = self.oldFrame;
            self.speed = self.oldSpeed;
            self.alpha = self.oldAlpha;
            //            让图片跟着动
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            self.status = TRPhotoStatusNormal;
        }
    }];
}
-(void)moveAction{
    self.center = CGPointMake(self.center.x+self.speed, self.center.y);
    //判断是否移除了屏幕
    if (self.frame.origin.x>=320) {
        CGRect frame = self.frame;
        frame.origin.x = - self.bounds.size.width;
        frame.origin.y = arc4random()%(int)(568-self.bounds.size.height);
        self.frame = frame;
    }
}
@end
@interface PhotoSeeViewController ()
@end
@implementation PhotoSeeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //    添加9张图片
    for (int i=1; i<12; i++) {
        TRPhoto *p = [[TRPhoto alloc]init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]];
        p.alpha = i*.1+.2;
        [p initStatus];
        p.imageView.image = image;
        [self.view addSubview:p];
    }
}
@end
