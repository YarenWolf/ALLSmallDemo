//
//  CALayer+XibConfiguration.m
//  YunDong55like
//
//  Created by junseek on 15-6-3.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "CALayer+XibConfiguration.h"


@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end