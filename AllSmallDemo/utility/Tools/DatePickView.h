//
//  DatePickView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/22.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DatePickerStyleBirthday,
    DatePickerStyleDate,
    DatePickerStyleTime,
    DatePickerStyleDateTime
} DatePickerStyle;
@class DatePickView;
@protocol DatePickViewDelegate <NSObject>
@optional  //可选
-(void)select:(DatePickView *)sview object:(id )dic;
@end
@interface DatePickView : UIView
@property (nonatomic,strong)NSDate  *miniDate;
@property (assign,nonatomic)DatePickerStyle Type;
@property (strong,nonatomic)NSString *strTitle;
@property (strong,nonatomic)NSDate *selectDate;
@property (nonatomic, weak) id<DatePickViewDelegate> delegate;
- (void)show;
- (void)hidden;
@end
