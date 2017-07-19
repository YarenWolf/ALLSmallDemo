//
//  FlyBirdViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/19.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "FlyBirdViewController.h"
#import "GameEngine.h"
@interface FlyBirdViewController ()
{
    UIImageView *_planeView;
    UIImageView *_cloudView1;
    UIImageView *_cloudView2;
    
    UIImageView *_bottomCloudView1;
    UIImageView *_bottomCloudView2;
    
    UIScrollView *_birdView;
    
    NSMutableArray *_wallsArray;
    
    UIButton *button;
    
}
@end

@implementation FlyBirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:91.0/255 green:145.0/255 blue:247.0/255 alpha:1];
    
    NSArray *arr = [UIFont familyNames];
    NSLog(@"%@",arr);
    
    [self uiConfig];
    
    [self configActions];
    
}

-(void)uiConfig
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
    
    //云
    _cloudView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud"]];
    _cloudView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud"]];
    [self.view addSubview:_cloudView1];
    [self.view addSubview:_cloudView2];
    
    _cloudView1.center = CGPointMake(400, 150);
    _cloudView2.center = CGPointMake(_cloudView1.center.x + 400, 140);
    
    //飞机
    _planeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plane%d",(arc4random()%11)+1]]];
    _planeView.center = CGPointMake(500, 100);
    [self.view addSubview:_planeView];
    
    //屏幕下方的云
    _bottomCloudView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    _bottomCloudView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    _bottomCloudView1.center = CGPointMake(160, self.view.frame.size.height - _bottomCloudView1.bounds.size.height/2);
    _bottomCloudView2.center = CGPointMake(_bottomCloudView1.center.x + 1280/2, _bottomCloudView1.center.y);
    [self.view addSubview:_bottomCloudView1];
    [self.view addSubview:_bottomCloudView2];
    
    //鸟
    _birdView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 252/7, 24)];
    UIImageView *birdImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flappy_fly"]];
    [_birdView addSubview:birdImgV];
    [self.view addSubview:_birdView];
    _birdView.center = CGPointMake(80, 200);
    
    _wallsArray = [[NSMutableArray alloc]init];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 100, 300, 100);
    //    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.27f green:0.52f blue:0.06f alpha:1.00f] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"yuweij" size:30];
    [self.view addSubview:button];
    button.hidden = YES;
    [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)configActions
{
    [[GameEngine sharedEngine]regTimerAction:^{
        _planeView.center = CGPointMake(_planeView.center.x - 5, _planeView.center.y);
    } withTime:2 withName:@"plane"];
    
    [[GameEngine sharedEngine]regTimerAction:^{
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"plane%d",(arc4random()%11)+1]];
        _planeView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        _planeView.image = img;
        _planeView.center = CGPointMake(500, 100+(arc4random()%100));
    } withTime:60*7 withName:@"newplane"];
    
    [[GameEngine sharedEngine]regTimerAction:^{
        _cloudView1.center = CGPointMake(_cloudView1.center.x - 3, _cloudView1.center.y);
        _cloudView2.center = CGPointMake(_cloudView2.center.x - 3, _cloudView2.center.y);
        if (_cloudView1.center.x < -200) {
            _cloudView1.center = CGPointMake(_cloudView2.center.x + 400, 150 + (arc4random()%200));
        }
        if (_cloudView2.center.x < -200) {
            _cloudView2.center = CGPointMake(_cloudView1.center.x + 400, 150 + (arc4random()%200));
        }
    } withTime:2 withName:@"cloud"];
    
    [[GameEngine sharedEngine]regTimerAction:^{
        [self resetX:_bottomCloudView1 andOffsetX:-2];
        [self resetX:_bottomCloudView2 andOffsetX:-2];
        if (_bottomCloudView2.center.x < -320) {
            [self resetX:_bottomCloudView2 andOffsetX:1280];
        }
        if (_bottomCloudView1.center.x < -320) {
            [self resetX:_bottomCloudView1 andOffsetX:1280];
        }
    } withTime:2 withName:@"bottomCloud"];
    
    //小鸟本身的图片变换
    [[GameEngine sharedEngine]regTimerAction:^{
        int newContentX = _birdView.contentOffset.x>200?0:_birdView.contentOffset.x + 252/7;
        _birdView.contentOffset = CGPointMake(newContentX, 0);
    } withTime:2 withName:@"birdImage"];
    
    //小鸟的位置也在动
    
    [[GameEngine sharedEngine]regTimerAction:^{
        _birdView.center = CGPointMake(80, _birdView.center.y + 0.5*speed);
        speed += 0.2;
    } withTime:1 withName:@"birdMove"];
    [[GameEngine sharedEngine]setValid:NO withName:@"birdMove"];
    
    [[GameEngine sharedEngine]regTimerAction:^{
        for (int i = _wallsArray.count - 1; i>=0; --i) {
            UIView *view = _wallsArray[i];
            [self resetX:view andOffsetX:-4];
            if (view.center.x < -30) {
                //超出屏幕,移除
                [view removeFromSuperview];
                [_wallsArray removeObject:view];
            }
        }
        UIView *v = [_wallsArray lastObject];
        if (v.center.x < 80 || _wallsArray.count == 0) {
            [self createWalls];
        }
    } withTime:2 withName:@"walls"];
    [[GameEngine sharedEngine]setValid:NO withName:@"walls"];
    
    
    [[GameEngine sharedEngine]regTimerAction:^{
        if (_birdView.center.y > self.view.frame.size.height) {
            [self gameOver];
        }
        for (UIView *view in _wallsArray) {
            if (CGRectIntersectsRect(_birdView.frame, view.frame)) {
                [self gameOver];
            }
        }
    } withTime:1 withName:@"gameover"];
    
    
}
static double speed = 0;

-(void)createWalls
{
    UIImageView *bottomWall = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_wall"]];
    UIImageView *topWall = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_wall"]];
    [self.view addSubview:bottomWall];
    [self.view addSubview:topWall];
    [_wallsArray addObject:bottomWall];
    [_wallsArray addObject:topWall];
    
    int random = arc4random()%250;
    topWall.center = CGPointMake(350, random-200);
    bottomWall.center = CGPointMake(350, topWall.center.y + 600);
    
    
}

-(void)resetX:(UIView *)view andOffsetX:(int)x
{
    view.center = CGPointMake(view.center.x + x, view.center.y);
}


-(void)tapAction
{
    speed = -6;
    [[GameEngine sharedEngine]setValid:YES withName:@"walls"];
    [[GameEngine sharedEngine]setValid:YES withName:@"birdMove"];
}

-(void)gameOver
{
    [self.view bringSubviewToFront:button];
    button.hidden = NO;
    //游戏结束
    [[GameEngine sharedEngine]over];
}

-(void)restart
{
    //恢复鸟和柱子的位置
    for (UIView *view in _wallsArray) {
        [view removeFromSuperview];
    }
    [_wallsArray removeAllObjects];
    _birdView.center = CGPointMake(80, 200);
    [[GameEngine sharedEngine]setValid:NO withName:@"birdMove"];
    [[GameEngine sharedEngine]setValid:NO withName:@"walls"];
    button.hidden = YES;
    [[GameEngine sharedEngine]restart];
}


@end








