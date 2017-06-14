//
//  PGScView.m
//  PGScViewDemo
//
//  Created by Paul.Guo on 15/7/23.
//  Copyright (c) 2015年 Paul.Guo. All rights reserved.
//

#import "PGScView.h"
/************** 一个item的宽 *************/
#define ITEMWIDTH 55
typedef void (^PGSBlock) (int page  , BOOL left , BOOL right , BOOL isTap );
@interface PGScrollView : UIScrollView
@property(nonatomic , strong)UIView *bcView;
@property(nonatomic , strong)NSArray *array;
@property(nonatomic , assign)CGFloat offsetX;
@property(nonatomic , strong)PGSBlock pgBlock;
@end
@interface PGScrollView ()<UIScrollViewDelegate>
@end
@implementation PGScrollView
- (UIView *)bcView{
    if (_bcView == nil) {
        _bcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ITEMWIDTH , 50 )];
        [self addSubview:_bcView];
    }return _bcView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewss];
    }return self;
}
- (void)initViewss{
    self.bcView.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    //点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}
- (void)setOffsetX:(CGFloat)offsetX{
    self.bcView.frame  = CGRectMake(offsetX*ITEMWIDTH/APPW, 0, ITEMWIDTH, 50 );
    [self setNeedsDisplay];
    /*** pgScView滑动效果 ***/
    int page = floor((offsetX - APPW / 2) / APPW) + 1;
    [self scrollToItem:page isTap:NO];
}
#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    int whereItem = point.x / ITEMWIDTH ;  //第几个item。从0开始
    [self scrollToItem:whereItem isTap:YES];
    self.bcView.frame = CGRectMake (ITEMWIDTH*whereItem , 0, ITEMWIDTH, 50);
    [self setNeedsDisplay];
}
/*** pgScView滑动效果 ***/
- (void)scrollToItem:(int)page isTap:(BOOL)isTap{
    BOOL leftBool  = ITEMWIDTH*page + ITEMWIDTH/2 > APPW/2 ? YES : NO ;
    BOOL rightBool = ITEMWIDTH*(self.array.count-page-1) + ITEMWIDTH/2  > APPW/2 ? YES : NO ;
    if (leftBool && rightBool) {
        if (self.pgBlock) {
            self.pgBlock (page , YES , YES , isTap) ;
        }
    } else {
        if (self.pgBlock) {
            self.pgBlock (page , !leftBool , !rightBool , isTap);
        }
    }
}
#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    UIFont *font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName : font ,
                          NSForegroundColorAttributeName : gradcolor,
                          NSParagraphStyleAttributeName : style};
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat textTextHeight = [obj boundingRectWithSize: CGSizeMake( ITEMWIDTH , INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dic context: nil].size.height;
        [obj drawInRect:CGRectMake(idx*ITEMWIDTH, (50-textTextHeight)/2 , ITEMWIDTH, 50) withAttributes:dic];
    }];
    [[UIColor clearColor] setStroke];
    CGContextStrokePath(ref);
    CGContextRestoreGState(ref);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bcView.frame];
    [path addClip];
    NSDictionary *dic1 = @{NSFontAttributeName : font ,
                           NSForegroundColorAttributeName : redcolor,
                           NSParagraphStyleAttributeName : style
                           };
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat textTextHeight = [obj boundingRectWithSize: CGSizeMake( ITEMWIDTH , INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dic context: nil].size.height;
        [obj drawInRect:CGRectMake(idx*ITEMWIDTH, (50-textTextHeight)/2 , ITEMWIDTH, 50) withAttributes:dic1];
    }];
    CGContextAddPath(ref, path.CGPath);
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(ref, kCGPathStroke);
}
@end
@interface PGScView ()<UIScrollViewDelegate>{
    int _newPage;
}
@property(nonatomic , strong)PGScrollView *pg;
@end
@implementation PGScView
- (PGScrollView *)pg{
    if (_pg==nil) {
        _pg = [[PGScrollView alloc] initWithFrame:CGRectMake(0, 0, ITEMWIDTH * self.array.count , 50 )];
        _pg.backgroundColor = [UIColor grayColor];;
        [self addSubview:_pg];
    }return _pg;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)initViews{
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentSize = CGSizeMake( ITEMWIDTH * self.array.count , 50);
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.pg.array = self.array ;
    __weak PGScView *_weakSV = self;
    _pg.pgBlock = ^(int page , BOOL left , BOOL right , BOOL isTap ) {
        //相应事件代理
        int oldPage = _newPage;
        _newPage = page ;
        if (_newPage != oldPage) {
            // item 改变
            if (_weakSV.pgDelegate && [_weakSV.pgDelegate respondsToSelector:@selector(itemWherePage:contentName:isTap:)]) {
                [_weakSV.pgDelegate itemWherePage:_newPage contentName:_weakSV.array[_newPage] isTap:isTap];
            }
        }
        //左右滑动的处理
        if (left && right) {
            [_weakSV setContentOffset:CGPointMake( +(ITEMWIDTH*page+ITEMWIDTH/2) - APPW/2 , 0) animated:YES];
            
        }
        //针对最左边，最右边的处理-左右滑动
        else {
            if (left && !right) {
                [_weakSV setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if(!left && right) {
                [_weakSV setContentOffset:CGPointMake(_weakSV.array.count*ITEMWIDTH-APPW , 0) animated:YES];
            }
        }
    };
}
- (void)setOffsetX:(CGFloat)offsetX{
    self.pg.offsetX = offsetX;
}
@end
