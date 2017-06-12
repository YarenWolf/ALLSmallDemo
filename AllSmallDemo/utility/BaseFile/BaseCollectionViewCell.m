//
//  BaseCollectionViewCell.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/12.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell
#pragma mark 初始化
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
///单例初始化
-(id)init {
    self = [super init];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(void)loadBaseTableCellSubviews{
    [self registerForKVO];
    [self initUI];
    [self loadSubViews];
}
-(void)loadSubViews {
    if (self.contentView) {
        for (id obj in [self subviews]) {
            if ([@"UITableViewCellScrollView" isEqualToString:NSStringFromClass([obj class])]) {
                //                UITableViewCell—>UITableViewCellScrollView—>UITableCellContentView
                //                cell.contentView.superview 获得。
                UIScrollView *scrollView = (UIScrollView*)obj;
                [scrollView setDelaysContentTouches:NO];//是否先等待一会儿看scrollview 是否有touch 事件发生
                [scrollView setExclusiveTouch:YES];//避免两个对象同时被触发
                break;
            }
        }
        [self setUserInteractionEnabled:YES];
        [self.contentView setUserInteractionEnabled:YES];
    }
}
#pragma mark KVO
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}
- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}
#pragma mark 以下子类重写
-(void)initUI{
    self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = fontTitle;
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = fontnomal;
    self.script.textColor = self.title.textColor = blacktextcolor;
    self.line = [[UIView alloc]init];
    //    [self addSubviews:self.icon,self.title,self.script,self.line,nil];
    DLog(@"请子类重写这个方法");
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    DLog(@"请子类重写这个方法");
}
- (NSArray *)observableKeypaths {
    DLog(@"请子类重写这个方法"); return nil;
}
- (void)updateUIForKeypath:(NSString *)keyPath {
    DLog(@"请子类重写这个方法");
}
-(void)prepareForReuse {
    [super prepareForReuse];
}
-(void)dealloc {
    [self unregisterFromKVO];
    [self deallocTableCell];
}
-(void) deallocTableCell {
    DLog(@"请子类重写这个方法");
}
@end