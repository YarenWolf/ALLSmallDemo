
#import "UIView+expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "SDDataCache.h"
#import "NSString+expanded.h"
#import "UIImage+expanded.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#define showProgressIndicator_width 250

@implementation UIView(Addition)

-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}
//-(BOOL) isKindOfClass: classObj 判断是否是这个类，包括这个类的子类和父类的实例；
//-(BOOL) isMemberOfClass: classObj 判断是否是这个类的实例,不包括子类或者父类；
-(BOOL) containsSubViewOfClassType:(Class)aclass {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:aclass]) {
            return YES;
        }
    }
    return NO;
}

- (CGPoint)frameOrigin {
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newSize.width, newSize.height);
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
	self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
	self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							self.frame.size.width, newHeight);
}
- (void)setMaxX:(CGFloat)maxX
{
    self.frameX = maxX - self.frameWidth;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.frameY = maxY - self.frameHeight;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

-(void)roundCorner
{
    self.layer.masksToBounds = YES;  
    self.layer.cornerRadius = 3.0;  
    self.layer.borderWidth = 1.0;
}

-(void)rotateViewStart;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 2 ];
    rotationAnimation.duration = 2;
    //rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0; 
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)rotateViewStop
{
    //CFTimeInterval pausedTime=[self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    self.layer.speed=0.0;
//    self.layer.timeOffset=pausedTime;
    //self.layer.timeOffset = 0.0;  
    //self.layer.beginTime = 0.0; 
//    CFTimeInterval timeSincePause =4+ (pausedTime - (int)pausedTime);
//    NSLog(@".....%f",timeSincePause);
//    self.layer.timeOffset=timeSincePause;
//    self.layer.beginTime = 0.0;
//    [NSTimer timerWithTimeInterval:timeSincePause target:self selector:@selector(removeAnimation:) userInfo:nil repeats:NO];
    [self.layer removeAllAnimations];
}
- (void)removeAnimation:(id)obj
{
    [self.layer removeAllAnimations];
}
-(void)addSubviews:(UIView *)view,...
{
    [self addSubview:view];
    va_list ap;
    va_start(ap, view);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        [self addSubview:akey];
        akey=va_arg(ap,id);
    }
    va_end(ap);
}

-(void)imageWithURL:(NSString *)url
{
    if (self.frame.size.width > showProgressIndicator_width) {
        [self imageWithURL:url useProgress:YES useActivity:YES];
    }
    else
    {
        [self imageWithURL:url useProgress:NO useActivity:YES];
    }
}
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity
{
    [self imageWithURL:url useProgress:useProgress useActivity:useActivity defaultImage:@"dd_album"];
}
-(void)imageWithURL:(NSString *)url useProgress:(BOOL)useProgress useActivity:(BOOL)useActivity defaultImage:(NSString *)strImage
{
    if ([self isKindOfClass:[UIImageView class]]) {
        UIView *tempView = nil;
        UIImageView *imgView = (UIImageView *)self;
        if ([strImage notEmptyOrNull]) {
            imgView.image=[UIImage imageNamed:strImage];
        }
        if (![url notEmptyOrNull]) {
            return;
        }
        if (useProgress) {
            CGFloat width = self.frame.size.width *0.8;
            CGFloat fX = (self.frame.size.width - width)/2.0;
            CGFloat fY = self.frame.size.height/2.0 - 10;
            UIProgressView *progressIndicator = [[UIProgressView alloc] initWithFrame:CGRectMake(fX, fY, width, 20)];
            [progressIndicator setProgressViewStyle:UIProgressViewStyleBar];
            [progressIndicator setProgressTintColor:RGBCOLOR(0 , 97,  167)];
            [progressIndicator setTrackTintColor:[UIColor grayColor]];
            tempView = progressIndicator;
            
            
            progressIndicator.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        }
        else if (useActivity)
        {
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activityIndicatorView setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
            [activityIndicatorView startAnimating];
            tempView = activityIndicatorView;
            
            activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            
        }
        
        [self addSubview:tempView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:strImage]];
        
        
    }else{
        UIButton *BtnView = (UIButton *)self;
        [BtnView sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:strImage]];
        
    }
}
+(UIView *)setTextViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextViewDelegate>)delegate
{
    UIView *row = [[UIView alloc]init];
    row.frame = frame;
//    row.layer.borderWidth = 1;
//    row.layer.borderColor = RGBACOLOR(225, 225, 225, 1.0).CGColor;
//    row.clipsToBounds = YES;
    
    UITextView *content = [[UITextView alloc]initWithFrame:CGRectMake(0, 6, W(row), H(row)  - 6)];
    [row addSubview:content];
    content.tag = 200;
    content.font = Font(13);
    content.delegate = delegate;
    UILabel *desc = [Utility labelWithFrame:CGRectMake(10, 10, W(row), 21) font:Font(13) color:[UIColor grayColor] text:placeholder];
    desc.tag = 100;
    [row addSubview:desc];
    
    return row;
}
@end
