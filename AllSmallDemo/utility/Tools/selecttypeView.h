//
//  selecttypeView.h
//  GuangFuBao
//
//  Created by 55like on 15/7/28.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selecttypeView : UIView

@property (nonatomic,copy) void (^selectypeveiwblock)(NSDictionary *dict);

-(void)setdatawitharr:(NSArray *)arr withselexttext:(NSString *)tex wihtimage:(NSString *)iamge;

@end
