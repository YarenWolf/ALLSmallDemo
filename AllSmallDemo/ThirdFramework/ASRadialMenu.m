//
//  S2LWorldRadiantMenu.m
//  snap2life4.0
//
//  Created by iOS on 26.05.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
#import "ASRadialMenu.h"
@implementation ASRadialSelectionView
@synthesize isSelected,delegate,timer,nameLabel,downloadBtn,randomColor;
- (id)initWithFrame:(CGRect)frame andText:(NSString*)_label{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 60, 60)];
    if (self) {
        [self removeConstraints:self.constraints];
        self.autoresizesSubviews = YES;
        self.randomColor = UIRandomColor;
        self.backgroundColor = self.randomColor;
        nameLabel = [UILabel new];
        nameLabel.frame = CGRectMake(0, 5, 57, 60);
        nameLabel.font = [UIFont boldSystemFontOfSize:10];
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.layer.shadowOpacity = 1.0;
        nameLabel.layer.shadowRadius = 0.0;
        nameLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        nameLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        [self addSubview:nameLabel];
        [self.layer setCornerRadius:30];
        self.layer.masksToBounds = YES;
        nameLabel.text = _label;
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake((60-nameLabel.frame.size.width)/2, (60-nameLabel.frame.size.width)/2, nameLabel.frame.size.width, nameLabel.frame.size.height);
        [self setIsSelected:NO];
    }
    return self;
}
-(void)downloadHandler{
    self.isSelected = YES;
}
-(void)setIsSelected:(BOOL)_isSelected{
    isSelected = _isSelected;
    if (isSelected) {
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1.6, 1.6)];
        [anim setCompletionBlock:^(POPAnimation *_anim, BOOL isCompleate) {
            [delegate performSelector:@selector(close:) withObject:self];
        }];
        [self pop_addAnimation:anim forKey:@"pop"];
    }else{
        downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadBtn.frame = CGRectMake(0, 0, 60, 60);
        [downloadBtn addTarget:self action:@selector(downloadHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downloadBtn];
    }
}
@end
@implementation ASRadialMenu
@synthesize origin,items,scale,delegate;
-(CGPoint) getCircularPos:(float)_angle{
	float a = M_PI/180 * _angle;
	float x = origin.x + (radius * sin(a));
	float y = origin.y + (radius * cos(a));
	return CGPointMake(x, y);
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		swipeRotationValue = 0.0;
		frictionAngle = 0.0;
        radius = 0.0;
        scale = 0.01;
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.AccessibilityLabel = @"closeMenu";
        CGFloat dimension = kASMAXRadius * 0.6;
        clearBtn.frame = CGRectMake((self.bounds.size.width - dimension) * 0.5, (self.bounds.size.height - dimension) * 0.5 ,dimension , dimension);
        [clearBtn addTarget:self action:@selector(closeHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
    }
    return self;
}
-(void)open{
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *item = (NSString*)obj;
        ASRadialSelectionView *view = [[ASRadialSelectionView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 10, 10) andText:item];
        view.delegate = self;
        view.alpha = 0.0;
        [self addSubview:view];
    }];
    swipeRotationValue = 830.0;
    scale = 0.01;
    [NSTimer scheduledTimerWithTimeInterval:0.01  target:self selector:@selector(animationOpen:) userInfo:nil repeats:YES];
}
-(void)closeHandler{
    selectedView = nil;
    [self close];
}
-(void)close:(ASRadialSelectionView*)_view{
    selectedView = _view;
    [self close];
}
-(void)close{
    swipeRotationValue += 720.0;
    [delegate performSelector:@selector(closeRadialMenu:) withObject:selectedView];
    [NSTimer scheduledTimerWithTimeInterval:0.01  target:self selector:@selector(animationClose:) userInfo:nil repeats:YES];
}
-(void)animationOpen:(NSTimer*)timer{
    if(radius < kASMAXRadius)radius++;
    if (scale < kASScalefactor) {
        scale += 0.01;
    }
    [self animationSchedule:timer];
}
-(void)animationClose:(NSTimer*)timer{
    if(radius > kASMINRadius)radius-=2;
    frictionAngle -= (frictionAngle-swipeRotationValue)/24;
	[self rotateMenu:frictionAngle];
    if (scale > 0.0) {
        scale -= 0.01;
    }else{
        [timer invalidate];
        [self removeFromSuperview];
    }
}
-(void)animationSchedule:(NSTimer*)timer{
	frictionAngle -= (frictionAngle-swipeRotationValue)/24;
	[self rotateMenu:frictionAngle];
	if (ceil(swipeRotationValue) == (ceil(frictionAngle)+1)) {
		[timer invalidate];
	}
}
-(void)rotateMenu:(CGFloat)a{
	CGFloat _angle = (360.0/(self.subviews.count-1));
	int i = 0;
	for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            CGFloat angle = (i*_angle);
            CGPoint pos = [self getCircularPos:angle-a];
            CGFloat scaleDimension = kASDimension * scale;
            CGRect newFrame = CGRectMake(pos.x-(scaleDimension*0.5), pos.y-(scaleDimension*0.5), scaleDimension, scaleDimension);
            button.frame = newFrame;
            button.alpha = scale;
            i++;
        }
	}
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    startLocation = [touch locationInView:self];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint moveLocation = [touch locationInView:self];
    CGFloat xx = moveLocation.x-startLocation.x;
    CGFloat yy = moveLocation.y-startLocation.y;
    CGFloat g = -0.01;
    if(startLocation.x > moveLocation.x) g = 0.01;
    CGFloat distance = sqrtf(xx*xx+yy*yy);
    swipeRotationValue += distance*g;
    [self rotateMenu:swipeRotationValue];
}

@end
