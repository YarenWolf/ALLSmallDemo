//
//  HitMouseViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "HitMouseViewController.h"
@interface Mouse : UIButton
@property (nonatomic, weak)HitMouseViewController *delegate;
@end
@implementation Mouse
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self setTitle:@"3" forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        [NSThread detachNewThreadSelector:@selector(countDownAction) toTarget:self withObject:nil];
    }
    return self;
}
-(void)countDownAction{
    for (int i=0; i<3; i++) {
        [NSThread sleepForTimeInterval:.5];
        int time = [[self titleForState:UIControlStateNormal]intValue];
        //    判断老鼠被删除了
        if (!self.superview) {
            return;
        }
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:@(time) waitUntilDone:NO];
    }
}
-(void)updateUI:(NSNumber *)number{
    int time = [number intValue];
    [self setTitle:[NSString stringWithFormat:@"%d",--time] forState:UIControlStateNormal];
    if (time == 0) {
        [self.delegate fail];
        [self removeFromSuperview];
    }
}
-(void)clicked{
    [self removeFromSuperview];
    //成功label+1
    [self.delegate success];
}
@end
@interface HitMouseViewController ()
@property (strong, nonatomic) UILabel *failLabel;
@property (strong, nonatomic) UILabel *successLabel;
@end
@implementation HitMouseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.failLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 200, 30)];
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
    [self.view addSubview:self.failLabel];
    [self.view addSubview:_successLabel];
    [NSThread detachNewThreadSelector:@selector(addMouse) toTarget:self withObject:nil];
}
-(void)addMouse{
    //开始添加老鼠
    while (YES) {
        [NSThread sleepForTimeInterval:1];
        Mouse *m = [[Mouse alloc]initWithFrame:CGRectMake(arc4random()%300, arc4random()%548, 20, 20)];
        m.delegate = self;
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:m waitUntilDone:NO];
    }
}
-(void)updateUI:(Mouse *)m{
    [self.view addSubview:m];
    //    setNeedsDisplay是刷新控件自己
    //    setNeedsLayout是刷新子控件
    [m setNeedsLayout];
}
-(void)success{
    int count = self.successLabel.text.intValue;
    self.successLabel.text = [NSString stringWithFormat:@"%d",count+1];
}

-(void)fail{
    int count = self.failLabel.text.intValue;
    self.failLabel.text = [NSString stringWithFormat:@"%d",count+1];
}
@end
