//
//  AlertViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "AlertViewController.h"
#import "LewPopupViewController.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"

@interface PopupView : UIView
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;


+ (instancetype)defaultPopupView;
@end

@implementation PopupView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _innerView = [[UIView alloc]initWithFrame:frame];
        UIButton *defaultb = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 30)];
        [defaultb setTitle:@"dismissAction" forState:UIControlStateNormal];
        [defaultb addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *fadb = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 190, 30)];
        [fadb setTitle:@"dismissViewFadeAction" forState:UIControlStateNormal];
        [fadb addTarget:self action:@selector(dismissViewFadeAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *slideb = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, 190, 30)];
        [slideb setTitle:@"dismissViewSlideAction" forState:UIControlStateNormal];
        [slideb addTarget:self action:@selector(dismissViewSlideAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *springb = [[UIButton alloc]initWithFrame:CGRectMake(0, 90, 190, 30)];
        [springb setTitle:@"dismissViewSpringAction" forState:UIControlStateNormal];
        [springb addTarget:self action:@selector(dismissViewSpringAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *dropb = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, 190, 30)];
        [dropb setTitle:@"dismissViewDropAction" forState:UIControlStateNormal];
        [dropb addTarget:self action:@selector(dismissViewDropAction:) forControlEvents:UIControlEventTouchUpInside];
        [_innerView addSubview:defaultb];
        [_innerView addSubview:fadb];
        [_innerView addSubview:slideb];
        [_innerView addSubview:springb];
        [_innerView addSubview:dropb];
        _innerView.backgroundColor = [UIColor redColor];
        [self addSubview:_innerView];
    }return self;
}
+ (instancetype)defaultPopupView{
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
}

- (void)dismissAction:(id)sender{
    [_parentVC lew_dismissPopupView];
}

- (void)dismissViewFadeAction:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (void)dismissViewSlideAction:(id)sender{
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeTopBottom;
    [_parentVC lew_dismissPopupViewWithanimation:animation];
}

- (void)dismissViewSpringAction:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (void)dismissViewDropAction:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}
@end

@interface AlertViewController ()
@end
@implementation AlertViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *defaultb = [[UIButton alloc]initWithFrame:CGRectMake(20, TopHeight, APPW-50, 50)];
    [defaultb setTitle:@"popupViewFadeAction" forState:UIControlStateNormal];
    [defaultb addTarget:self action:@selector(popupViewFadeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *fadb = [[UIButton alloc]initWithFrame:CGRectMake(20, 2*TopHeight, APPW-50, 50)];
    [fadb setTitle:@"popupViewSlideAction" forState:UIControlStateNormal];
    [fadb addTarget:self action:@selector(popupViewSlideAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *slideb = [[UIButton alloc]initWithFrame:CGRectMake(20, 3*TopHeight, APPW-50, 50)];
    [slideb setTitle:@"popupViewSpringAction" forState:UIControlStateNormal];
    [slideb addTarget:self action:@selector(popupViewSpringAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *springb = [[UIButton alloc]initWithFrame:CGRectMake(20, 4*TopHeight, APPW-50, 50)];
    [springb setTitle:@"popupViewDropAction" forState:UIControlStateNormal];
    [springb addTarget:self action:@selector(popupViewDropAction:) forControlEvents:UIControlEventTouchUpInside];
    defaultb.backgroundColor = fadb.backgroundColor = slideb.backgroundColor = springb.backgroundColor = redcolor;
    [self.view addSubviews:defaultb,fadb,slideb,springb,nil];
    
}
- (void)popupViewFadeAction:(id)sender{
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
- (void)popupViewSlideAction:(id)sender{
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:view animation:animation dismissed:^{
        NSLog(@"动画结束");
    }];
}
- (void)popupViewSpringAction:(id)sender{
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
- (void)popupViewDropAction:(id)sender{
    PopupView *view = [PopupView defaultPopupView];
    view.parentVC = self;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationDrop new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
@end
