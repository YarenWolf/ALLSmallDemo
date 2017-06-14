//
//  GravityViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/12.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "GravityViewController.h"
//5种: 碰撞.重力.推力.吸附.捕捉
@interface GravityViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic) UIDynamicAnimator *animator;//动力世界,对于autolayout兼容不是很好, 我们用frame
@property (nonatomic) UIGravityBehavior *gravityBehavior;//重力行为
@property (nonatomic) UICollisionBehavior *collisionBehavior;//碰撞行为
@end
@implementation GravityViewController
#pragma mark - UICollisionBehavior Delegate
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    UIImageView *iv = (UIImageView *)item;
    [UIView animateWithDuration:2 animations:^{
        iv.alpha = 0.0;
    } completion:^(BOOL finished) {
        [iv removeFromSuperview];
        [self.gravityBehavior removeItem:iv];
        [self.collisionBehavior removeItem:iv];
    }];
}

#pragma mark - 方法 Methods
- (void)createKupao:sender{
    CGFloat width = 60;
    CGFloat x = arc4random()% (long)(self.view.frame.size.width - width);
    CGRect frame = CGRectMake(x, width, width, width);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [self.view addSubview:imageView];
    imageView.image = [UIImage animatedImageNamed:@"loading_" duration:.4];
    //把小人添加到重力行为中,让他具有重力效果
    [self.gravityBehavior addItem:imageView];
    //小人添加到碰撞行为中
    [self.collisionBehavior addItem:imageView];
}
#pragma mark - 生命周期 Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravityBehavior];
    [self.animator addBehavior:self.collisionBehavior];
    //每隔一秒钟生成一个小人
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(createKupao:) userInfo:nil repeats:YES];
}
- (UIGravityBehavior *)gravityBehavior {
    if(_gravityBehavior == nil) {
        _gravityBehavior = [[UIGravityBehavior alloc] init];
        //_gravityBehavior.magnitude = 0.8; //重力大小
        //_gravityBehavior.angle = M_PI_2;//重力方向
        //通过矢量来设置重力的大小和方向
        _gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    }return _gravityBehavior;
}
- (UICollisionBehavior *)collisionBehavior {
    if(_collisionBehavior == nil) {
        _collisionBehavior = [[UICollisionBehavior alloc] init];
        //把当前动力世界的边缘变为可碰撞
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        //通过协议,可以监听碰撞行为的发生
        _collisionBehavior.collisionDelegate = self;
    }return _collisionBehavior;
}

@end


