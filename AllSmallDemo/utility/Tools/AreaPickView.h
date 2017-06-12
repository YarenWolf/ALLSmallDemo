//
//  AreaPickView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/22.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    AreaPickerWithStateAndCity,
    AreaPickerWithStateAndCityAndDistrict
} AreaPickerStyle;
@interface ALocation : NSObject
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;

@end
@class AreaPickView;

@protocol AreaPickerDatasource <NSObject>
- (NSArray *)areaPickerData:(AreaPickView *)picker;
@end
@protocol AreaPickerDelegate <NSObject>
@optional
- (void)pickerDidChaneStatus:(AreaPickView *)picker;
@end
@interface AreaPickView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) id <AreaPickerDelegate> delegate;
@property (assign, nonatomic) id <AreaPickerDatasource> datasource;
@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong, nonatomic) ALocation *locate;
@property (nonatomic) AreaPickerStyle pickerStyle;
- (id)initWithStyle:(AreaPickerStyle)pickerStyle withDelegate:(id <AreaPickerDelegate>)delegate andDatasource:(id <AreaPickerDatasource>)datasource;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
