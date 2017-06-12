//
//  selecttypeView.m
//  GuangFuBao
//
//  Created by 55like on 15/7/28.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "selecttypeView.h"


@implementation selecttypeView
{
    UIScrollView *scrollView;
    NSArray *dataArr;
    NSString *selecttext;
    NSString *image;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollView];
    }
    return self;
}

-(void)initUI
{
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat stary = 0.0;
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dict = dataArr[i];
        if([dict valueForJSONKey:@"name"]){
        stary = [self createbutton:CGRectMake(0, stary, W(self), 44) withtitle:[dict valueForJSONStrKey:@"name"] withtag:i + 10];
        }else{
        stary = [self createbutton:CGRectMake(0, stary, W(self), 44) withtitle:[dict valueForJSONStrKey:@"companyname"] withtag:i + 10];
        }
    }
    scrollView.frame = CGRectMake(0, 0, W(self), H(self));
    CGFloat height = stary>H(scrollView) + 1?stary:H(scrollView) +1;
    scrollView.contentSize = CGSizeMake(0, height);
    
    
}

-(CGFloat)createbutton:(CGRect)frame withtitle:(NSString *)title withtag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    UIImage *img = [UIImage imageNamed:image];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    UILabel *titleLable = [Utility labelWithFrame:CGRectMake(Boardseperad, (H(button) - 20)/2.0, W(button) - 2*Boardseperad - img.size.width, 20) font:fontTitle color:blacktextcolor text:title];
    titleLable.tag = button.tag + 100;
    [button addSubview:titleLable];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(W(button) - Boardseperad - img.size.width, (H(button) - img.size.height)/2.0, img.size.width, img.size.height)];
    imageview.hidden = YES;
    imageview.image = img;
    imageview.tag = button.tag + 200;
    [button addSubview:imageview];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(Boardseperad, H(button) - 1, W(button) - 2*Boardseperad, 1)];
    line.image = [UIImage imageNamed:@"userLine"];
    [button addSubview:line];
    
    if ([titleLable.text isEqualToString:selecttext]) {
        titleLable.textColor = redcolor;
        imageview.hidden = NO;
    }
    
    return YH(button);
    
}

-(void)btnAction:(UIButton *)btn
{
    for (int i = 0; i < dataArr.count; i++) {
        UIButton *button = (UIButton *)[scrollView viewWithTag:10 + i];
        UILabel *titlelable = (UILabel *)[button viewWithTag:button.tag + 100];
        titlelable.textColor = blacktextcolor;
        UIImageView *imageview = (UIImageView *)[button viewWithTag:button.tag + 200];
        imageview.hidden = YES;
    }
    UILabel *titlelable = (UILabel *)[btn viewWithTag:btn.tag + 100];
    titlelable.textColor = redcolor;
    UIImageView *imageview = (UIImageView *)[btn viewWithTag:btn.tag + 200];
    _selectypeveiwblock(dataArr[btn.tag - 10]);
    imageview.hidden = NO;
}

-(void)setdatawitharr:(NSArray *)arr withselexttext:(NSString *)tex wihtimage:(NSString *)iamge
{
    selecttext = tex;
    dataArr = arr;
    image = iamge;
    [self initUI];
}


@end
