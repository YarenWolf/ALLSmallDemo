//
//  YZPaintView.h
//  涂鸦画板
//
//  Created by yz on 14-8-8.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YZHandleImageViewBlock)(UIImage *image);

@interface YZHandleImageView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) YZHandleImageViewBlock block;

@end
@interface YZPaintView : UIView

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIImage *image;

- (void)clearScreen;
- (void)undo;

@end
