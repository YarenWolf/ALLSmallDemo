//
//  YZLockView.m
//  手势解锁
//
//  Created by yz on 14-8-7.
//  Copyright (c) 2014年 iThinker. All rights reserved.
#import "YZLockView.h"
#define kCount 9
@interface YZLockView ()
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic, assign) CGPoint currentMovePoint;
@end
@implementation YZLockView
- (NSMutableArray *)selectedButtons{
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }return _selectedButtons;
}
// 通过代码
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }return self;
}
// 初始化
- (void)setUp{
    // 创建9个按钮
    for (int i = 0;i < kCount; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        // 设置按钮默认的图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        // 设置按钮选中的图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        btn.tag= i;
        // 将btn添加到视图
        [self addSubview:btn];
    }
}
// 设置按钮的位置,因为在init方法中可能没有frame,在这里设置最准确
- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置按钮的位置
    for (int i = 0; i < self.subviews.count; i++) {
        // 取出按钮
        UIButton *btn = self.subviews[i];
        // 设置位置
        CGFloat w = 74;
        CGFloat h = 74;
        int totalCol = 3;
        CGFloat col = i % totalCol;
        CGFloat row = i / totalCol;
        CGFloat margin = (self.bounds.size.width - totalCol * w) / (totalCol + 1);
        CGFloat x = col * (margin + w) + margin;
        CGFloat y = row * (margin + h);
        btn.frame = CGRectMake(x, y, w, h);
    }
}

// 根据touches集合获取对应的触摸点位置
- (CGPoint)pointWithTouches:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self];
    return pos;
}
#warning 根据不同的业务逻辑，划分功能，一个功能里面不要处理太多业务逻辑，以后开发就不好找了。
// 根据触摸点获得对应的按钮
- (UIButton *)buttonWithPoint:(CGPoint)point{
    for (int i = 0; i < kCount; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat wh = 24;
        CGPoint center = btn.center;
        CGFloat x = center.x - wh * 0.5;
        CGFloat y = center.y - wh * 0.5;
        CGRect r = CGRectMake(x, y, wh, wh);
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    // 都没有找到就返回Nil
    return nil;
}
// 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _currentMovePoint = CGPointMake(-10, -10);
    // 1.获取触摸点
    CGPoint pos =[self pointWithTouches:touches];
    // 2.获取触摸的按钮
    UIButton *btn = [self buttonWithPoint:pos];
    // 3.设置状态
    if (btn && btn.selected == NO) { // 摸到按钮
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
        
    }
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 1.获取触摸点
    CGPoint pos =[self pointWithTouches:touches];
    // 2.获取触摸的按钮
    UIButton *btn = [self buttonWithPoint:pos];
    // 3.设置状态
    if (btn && btn.selected == NO) { // 摸到按钮
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
    }else{
        _currentMovePoint = pos;
    }
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // 获取路径
    NSMutableString *str = [NSMutableString string];
    for (UIButton *b  in _selectedButtons) {
        [str appendFormat:@"%ld",b.tag];
    }
    if ([_delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        [_delegate lockView:self didFinishPath:str];
    }
    // 全部取消选中
    [self.selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    // 清空数组
    [self.selectedButtons removeAllObjects];
    // 重绘
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    if (self.selectedButtons.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *b = _selectedButtons[i];
        if (i == 0) {
            [path moveToPoint:b.center];
        }else{
            [path addLineToPoint:b.center];
        }
    }
    // 如果不是原点才需要画，但是有时候我们也需要画原点，怎么做，是不是可以搞个默认的初始值啊
    // 注意啊，这个初始值不能在初始化里面搞，应该在触摸开始的时候设置
    if (!CGPointEqualToPoint(_currentMovePoint,CGPointMake(-10, -10))) {
        [path addLineToPoint:_currentMovePoint];
    }
    path.lineWidth = 8;
    // 设置线段样式
    path.lineJoinStyle = kCGLineJoinBevel;
    [[UIColor greenColor] set];
    [path stroke];
}
@end
