//
//  CLLockLabel.m
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockLabel.h"
#import "CoreLockConst.h"

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Anim)



/*
 *  摇动
 */
-(void)shake;




@end
@implementation CALayer (Anim)


/*
 *  摇动
 */
-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .1f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end



@implementation CLLockLabel




-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}


/*
 *  视图初始化
 */
-(void)viewPrepare{
    
    self.font = [UIFont systemFontOfSize:16.0f];
}





/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg{
    
    self.text = msg;
    self.textColor = CoreLockCircleLineNormalColor;
}



/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg{
    
    self.text = msg;
    self.textColor = CoreLockWarnColor;
    
    //添加一个shake动画
    [self.layer shake];
}


@end
