//
//  SelectDateView.m
//  ZKwwlk
//
//  Created by junseek on 14-7-24.
//  Copyright (c) 2014年 五五来客. All rights reserved.
//

#import "DatePickView.h"

@interface DatePickView (){
    UIDatePicker *datePicker;
    UILabel *Title;
}
@end
@implementation DatePickView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
        UIControl *closeC=[[UIControl alloc]initWithFrame:self.bounds];
        [closeC addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeC];
        UIImageView *im=[Utility imageviewWithFrame:CGRectMake(0, APPH-(216+44), APPW, 44) defaultimage:@"hidebutton"];
        [self addSubview:im];
        im.backgroundColor=[UIColor whiteColor];
        
        UIButton *closeBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn1.frame=CGRectMake(20,  Y(im), 120, 44);
        [closeBtn1 setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [closeBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [closeBtn1 addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn1];
        
        UIButton *OKBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
        OKBtn1.frame=CGRectMake(APPW-140,  Y(im), 120, 44);
        [OKBtn1 setTitle:@"确定" forState:UIControlStateNormal];
        [OKBtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [OKBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [OKBtn1 addTarget:self action:@selector(OkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:OKBtn1];
        
        Title=[Utility labelWithFrame:CGRectMake(60, Y(im), APPW-120, 44) font:fontTitle color:blacktextcolor text:@"" textAlignment:NSTextAlignmentCenter];
        [self addSubview:Title];
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,YH(im),APPW,216)];
        //设置中文显示
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        [datePicker setLocale:locale];
        datePicker.minimumDate=[NSDate date];
        //[[UIDatePicker appearance] setTintColor:RGBCOLOR(245, 245, 245)];
        datePicker.backgroundColor = RGBCOLOR(236, 234, 240);
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
        [self addSubview:datePicker];
    }
    return self;
}
-(void)closeButtonClicked{
    [self hidden];
}
-(void)OkButtonClicked{
    if ([self.delegate respondsToSelector:@selector(select:object:)]) {
        [self.delegate select:self object:datePicker.date];
    }
    [self hidden];
}
- (void)show{
    Title.text=self.strTitle;
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    if (self.Type == DatePickerStyleBirthday) {
        datePicker.minimumDate=nil;
        datePicker.maximumDate=[NSDate date];
        datePicker.datePickerMode = UIDatePickerModeDate;
    }else if (self.Type == DatePickerStyleDate){
        datePicker.datePickerMode = UIDatePickerModeTime;
    }else if (self.Type == DatePickerStyleTime){
        datePicker.minimumDate=[NSDate date];
        datePicker.datePickerMode = UIDatePickerModeDate;
    }else{
        datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    }
    if (self.selectDate) {
        [datePicker setDate:self.selectDate];
    }
    if (self.miniDate) {
        [datePicker setMinimumDate:self.miniDate];
    }
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{self.alpha = 1.0f;} completion:^(BOOL finished) {}];
}

- (void)hidden{
    [UIView animateWithDuration:0.3 animations:^{self.alpha = 0.0f;} completion:^(BOOL finished) {self.hidden = YES;}];
}

@end
