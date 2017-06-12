//
//  shareView.m
//  GuangFuBao
//
//  Created by 55like on 15/7/30.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "shareView.h"

@implementation shareView
{
    UIView *contentView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self initUI];
    }
    return self;
}
//43 34
-(void)initUI
{
    contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel *titleLable = [Utility labelWithFrame:CGRectMake(0, Boardseperad, W(self), 20) font:fontTitle color:blacktextcolor text:@"分享到"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLable];
    
    NSArray *titleArr = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"腾讯微博",@"QQ好友",@"QQ空间"];
    NSArray *imageArr = @[@"share01",@"share02",@"share03",@"share04",@"share05",@"share06"];
    CGFloat starx = 0.0;
    CGFloat height = 0.0;
    CGFloat stary = YH(titleLable) + Boardseperad;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10 + i;
        button.frame = CGRectMake(starx, stary, W(self)/4.0, 74);
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        starx = XW(button);
        
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake((W(button) - image.size.width)/2.0, Boardseperad, image.size.width, image.size.height)];
        imV.image = image;
        [button addSubview:imV];
        
        UILabel *namelable = [Utility labelWithFrame:CGRectMake(0, H(button) - 20, W(button), 20) font:fontTitle color:blacktextcolor text:titleArr[i]];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
        if (i == 3) {
            starx = 0.0;
            stary = YH(button);
            
        }
        height = YH(button);
    }
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, height + Boardseperad, W(self), 1)];
    line.image = [UIImage imageNamed:@"userLine"];
    [contentView addSubview:line];
    
    UIButton *cansalbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cansalbtn.frame = CGRectMake(0, YH(line), W(self), 40);
    cansalbtn.titleLabel.font = fontTitle;
    [cansalbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cansalbtn setTitleColor:blacktextcolor forState:UIControlStateNormal];
    cansalbtn.tag = 100;
    [cansalbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cansalbtn];
    
    contentView.frame = CGRectMake(0, H(self) - YH(cansalbtn) - Boardseperad, W(self), YH(cansalbtn) + Boardseperad);
    
}

-(void)btnAction:(UIButton *)btn
{
    _shareViewblock(btn.tag);
}



@end
