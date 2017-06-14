//
//  JourneyView.h
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MsgModel : NSObject
@property (strong,nonatomic) NSString * address;//地点
@property (strong,nonatomic) NSString * motive;//目的
@property (strong,nonatomic) NSString * date;//时间
@property (strong,nonatomic) UIColor * color;
@end


@interface JourneyView : UIView
@property (strong,nonatomic) NSArray * msgModelArray;


@property (strong,nonatomic) NSArray * colorArray;
@end
