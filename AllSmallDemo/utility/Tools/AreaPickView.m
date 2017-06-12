//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "AreaPickView.h"
#import <QuartzCore/QuartzCore.h>
#define kDuration 0.3
@implementation ALocation

@end
@interface AreaPickView (){
    NSArray *provinces, *cities, *areas;
}
@end
@implementation AreaPickView
@synthesize delegate=_delegate;
@synthesize datasource=_datasource;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;

-(ALocation *)locate{
    if (_locate == nil) {
        _locate = [[ALocation alloc] init];
    }return _locate;
}
- (id)initWithStyle:(AreaPickerStyle)pickerStyle withDelegate:(id <AreaPickerDelegate>)delegate andDatasource:(id <AreaPickerDatasource>)datasource{
    self = [[AreaPickView alloc]initWithFrame:CGRectMake(0, 0, APPW, 300)] ;
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.datasource = datasource;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        provinces = [self.datasource areaPickerData:self] ;
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
        if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            if (areas.count > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
        } else{
            self.locate.city = [cities objectAtIndex:0];
        }
    }
    return self;
}



#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict)?3:2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:return [provinces count];break;
        case 1:return [cities count];break;
        case 2:if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {return [areas count];break;}
        default:return 0;break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:return [[provinces objectAtIndex:row] objectForKey:@"state"];break;
            case 1:return [[cities objectAtIndex:row] objectForKey:@"city"];break;
            case 2:if([areas count] > 0) {return [areas objectAtIndex:row];break;}
            default:return  @"";break;
        }
    } else{
        switch (component) {
            case 0:return [[provinces objectAtIndex:row] objectForKey:@"state"];break;
            case 1:return [cities objectAtIndex:row];break;
            default:return @"";break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    
}


#pragma mark - animation
- (void)showInView:(UIView *) view{
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, view.frame.size.width, self.frame.size.height);
    }];
    
}
- (void)cancelPicker{
    [UIView animateWithDuration:0.3 animations:^{self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
-(NSArray *)areaPickerData:(AreaPickView *)picker{
    NSArray *data;
    if (picker.pickerStyle == AreaPickerWithStateAndCityAndDistrict) {
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]] ;
    } else{
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]] ;
    }
    return data;
}
@end
