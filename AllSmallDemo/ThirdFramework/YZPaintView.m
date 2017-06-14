//
//  YZPaintView.m
//  涂鸦画板
//
//  Created by yz on 14-8-8.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import "YZPaintView.h"


@interface UIImage (Tool)

+ (instancetype)captureWithView:(UIView *)view;

@end
@implementation UIImage (Tool)

+ (instancetype)captureWithView:(UIView *)view
{
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    // 2.获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3.渲染图层
    [view.layer renderInContext:ctx];
    
    // 4.获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


@end


@interface YZHandleImageView()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation YZHandleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        
        
        // 1.添加imageView
        [self addImageView];
        
        // 2.添加手势
        [self addGestures];
        
    }
    return self;
}

- (void)addImageView
{
    UIImageView *iV = [[UIImageView alloc] initWithFrame:self.bounds];
    iV.userInteractionEnabled = YES;
    _imageV = iV;
    [self addSubview:_imageV];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    NSLog(@"layoutSubviews%@", NSStringFromCGRect(_imageV.frame));
//    _imageV.frame = self.bounds;
//    [self addGestures];
//}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageV.image = image;
    
}
- (void)addGestures
{
    // 1.拖动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_imageV addGestureRecognizer:pan];
    
    // 2.旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [_imageV addGestureRecognizer:rotation];
    // 3.捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [_imageV addGestureRecognizer:pinch];
    
    // 4.长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_imageV addGestureRecognizer:longPress];
    
    // 5.点按
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_imageV addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _imageV.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            _imageV.alpha = 1;
        } completion:^(BOOL finished) {
            // 截屏
            UIImage *image = [UIImage captureWithView:self];
            
            // 将图片传给控制器
            if (_block) {
                _block(image);
            }
            
            // 处理图片完毕,销毁当前视图
            [self removeFromSuperview];
        }];
        
    }];
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint pos = [pan translationInView:_imageV];
    _imageV.transform = CGAffineTransformTranslate(_imageV.transform, pos.x, pos.y);
    
    // 复位
    [pan setTranslation:CGPointZero inView:_imageV];
    
}
- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    _imageV.transform = CGAffineTransformRotate(_imageV.transform, rotation.rotation);
    rotation.rotation = 0;
}
- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    
    _imageV.transform = CGAffineTransformScale(_imageV.transform, pinch.scale, pinch.scale);
    
    // 复位
    pinch.scale = 1;
}

// 这个方法会调用两次，长按开始一次，结束一次
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _imageV.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                _imageV.alpha = 1;
            } completion:^(BOOL finished) {
                // 截屏
                UIImage *image = [UIImage captureWithView:self];
                // 将图片传给控制器
                if (_block) {
                    _block(image);
                }
                
                // 处理图片完毕,销毁当前视图
                [self removeFromSuperview];
            }];
            
        }];
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end

@interface YZPaintPath : UIBezierPath

// 路径颜色
@property (nonatomic, strong) UIColor *pathColor;

// 起点
@property (nonatomic, assign) CGPoint  startPoint;

// 快速创建对象
+ (instancetype)bezierPathWithColor:(UIColor *)pathColor;


+ (instancetype)bezierPathWithColor:(UIColor *)pathColor lineWidth:(CGFloat)lineWidth startPoint:(CGPoint)startPoint;

@end

@implementation YZPaintPath

+ (instancetype)bezierPathWithColor:(UIColor *)pathColor
{
    YZPaintPath *path = [[YZPaintPath alloc] init];
    path.pathColor = pathColor;
    
    return path;
}

+ (instancetype)bezierPathWithColor:(UIColor *)pathColor lineWidth:(CGFloat)lineWidth startPoint:(CGPoint)startPoint
{
    YZPaintPath *path = [[YZPaintPath alloc] init];
    path.pathColor = pathColor;
    path.lineWidth = lineWidth;
    path.startPoint = startPoint;
    
    [path moveToPoint:startPoint];
    
    return path;
    
}

@end


@interface YZPaintView()
{
    UIBezierPath *_path;
}

@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation YZPaintView

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}
-(instancetype)init{
    self = [super init];
    if(self){
        _width = 2;
        _color = [UIColor blackColor];
    }return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _width = 2;
        _color = [UIColor blackColor];
    }return self;
}
// 根据touches集合获取对应的触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}


// 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取起点
    CGPoint startP = [self pointWithTouches:touches];
    
    // 2.创建贝塞尔路径
//    YZPaintPath *path = [YZPaintPath bezierPathWithColor:_color];
    
//    [path moveToPoint:startP];
    // 设置状态：注意在一创建的时候就设置。到时候直接画就好了。
//    path.lineWidth = _width;
//    
//    _path = path;
    NSLog(@"%@",_color);
    YZPaintPath *path = [YZPaintPath bezierPathWithColor:_color lineWidth:_width startPoint:startP];
    _path = path;
    [_paths addObject:path];
}

// 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取移动点
    CGPoint moveP = [self pointWithTouches:touches];
    
    // 想给上面的路径添加直线，是不是要拿到上面的路径啊.
    // 添加线段
    [_path addLineToPoint:moveP];
    
    // 画线(调用drawRect)
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.paths addObject:image];
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 调用drawRect每次都会重新绘制，将之前的清掉
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (YZPaintPath *path in self.paths) {
        // 在这是有问题的，每根线段的宽度都是一样的
//        [[UIColor redColor] set];
//        path.lineWidth = _width;
        
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else{
            
            [path.pathColor set];
            [path stroke];
        }
    }
    
    // 能直接画在后面吗，选择图片后，之后画的线是不是应该在图片的上面啊，不能被图片覆盖。画图是不是也要有顺序，那怎么能有顺序，是不是把它加入数组里，
    
}

- (void)clearScreen{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}
- (void)undo
{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

@end
