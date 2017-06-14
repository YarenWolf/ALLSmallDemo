//
//  YZLockView.h
//  手势解锁
//
//  Created by yz on 14-8-7.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZLockView;
@protocol YZLockViewDelegate <NSObject>
@optional
- (void)lockView:(YZLockView *)lockView didFinishPath:(NSString *)path;
@end
@interface YZLockView : UIView
@property (nonatomic, strong) id<YZLockViewDelegate> delegate;
@end
