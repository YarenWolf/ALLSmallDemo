//
//  TaijiView.m
//  太极
//
//  Created by qianfeng on 15-1-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

//
//  TaijiView.h
//  太极
//
//  Created by qianfeng on 15-1-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaijiView : UIView

- (void)setAnimationWithTimeInterval:(CGFloat)timeInterval;

@end


#define RATIO (0.2)

@interface TaijiView ()
{
    CGPoint _originPoint;
    CGPoint _leftPoint;
    CGPoint _rightPoint;
    CGFloat _baseRadius;
    CGFloat _ratio;
}
@end

@implementation TaijiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat originX = frame.size.width / 2;
        CGFloat originY = frame.size.height / 2;
        _originPoint = CGPointMake(originX, originY);
        _baseRadius = ((originX <= originY)?originX:originY) - 5;
        
        CGFloat leftX = originX - _baseRadius / 2;
        CGFloat leftY = originY;
        _leftPoint = CGPointMake(leftX, leftY);
        
        CGFloat rightX = originX + _baseRadius / 2;
        CGFloat rightY = originY;
        _rightPoint = CGPointMake(rightX, rightY);
        
        _ratio = RATIO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 2);
//    CGContextMoveToPoint(ctx, _leftPoint.x, _leftPoint.y);
    CGContextAddArc(ctx, _leftPoint.x, _leftPoint.y, _baseRadius / 2, M_PI, 0, 1);
//    CGContextMoveToPoint(ctx, _rightPoint.x, _rightPoint.y);
    CGContextAddArc(ctx, _rightPoint.x, _rightPoint.y, _baseRadius / 2, M_PI, 0, 0);
//    CGContextMoveToPoint(ctx, _originPoint.x, _originPoint.y);
    CGContextAddArc(ctx, _originPoint.x, _originPoint.y, _baseRadius, 0, M_PI, 0);
    CGContextFillPath(ctx);
    
    CGContextAddArc(ctx, _originPoint.x, _originPoint.y, _baseRadius, M_PI, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    CGContextAddArc(ctx, _leftPoint.x, _leftPoint.y, _baseRadius * _ratio, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextAddArc(ctx, _rightPoint.x, _rightPoint.y, _baseRadius * _ratio, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
}

- (void)setAnimationWithTimeInterval:(CGFloat)timeInterval {
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}

- (void)timerUpdate {
//    self.layer.transform = CATransform3DRotate(self.layer.transform, M_PI_2/60, 0.5, 0.5, 0.5);
    self.transform = CGAffineTransformRotate(self.transform, -M_PI / 180);
}

@end
