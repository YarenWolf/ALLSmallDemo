//
//  shareView.h
//  GuangFuBao
//
//  Created by 55like on 15/7/30.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareView : UIView

@property (nonatomic, copy) void (^shareViewblock) (NSInteger tag);

@end
