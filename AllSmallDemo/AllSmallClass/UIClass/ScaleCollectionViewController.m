
//
//  ScaleCollectionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "ScaleCollectionViewController.h"
static const CGFloat HMItemWH = 100;
/** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
static CGFloat const HMActiveDistance = 150;
/** 缩放因素: 值越大, item就会越大 */
static CGFloat const HMScaleFactor = 0.6;
@interface HMLineLayout : UICollectionViewFlowLayout
@end
@implementation HMLineLayout
- (instancetype)init{
    if (self = [super init]) {
        // 每个cell的尺寸
        self.itemSize = CGSizeMake(HMItemWH, HMItemWH);
        CGFloat inset = (self.collectionView.frame.size.width - HMItemWH) * 0.5;
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
        // 设置水平滚动
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = HMItemWH * 0.7;
    }return self;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    // 计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    // 3.遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    // 1.取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 2.遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 如果不在屏幕上,直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        // 每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        // 差距越小, 缩放比例越大// 根据跟屏幕最中间的距离计算缩放比例
        CGFloat scale = 1 + HMScaleFactor * (1 - (ABS(itemCenterX - centerX) / HMActiveDistance));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}
@end
@interface ScaleCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@end
@implementation ScaleCollectionViewController
static NSString *const ID = @"image";
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat w = self.view.frame.size.width;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, w, 200) collectionViewLayout:[[HMLineLayout alloc] init]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

@end
