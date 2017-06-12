//
//  CeilingCollectionViewLayout.m
//  薛超APP框架
//
//  Created by Super on 2017/5/31.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "CeilingCollectionViewLayout.h"

@implementation CeilingCollectionViewLayout
+(instancetype)sharedFlowlayoutWithCellSize:(CGSize)size groupInset:(UIEdgeInsets)insets itemSpace:(CGFloat)itemspace linespace:(CGFloat)linespace{
    CeilingCollectionViewLayout *layout = [[CeilingCollectionViewLayout alloc]initWithCellSize:size groupInset:insets itemSpace:itemspace linespace:linespace];
    return layout;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [answer addObject:layoutAttributes];
    }];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            if (numberOfItemsInSection > 0) {
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            } else {
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter  atIndexPath:lastObjectIndexPath];
            }
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(MAX(contentOffset.y + cv.contentInset.top,(CGRectGetMinY(firstObjectAttrs.frame) - headerHeight)),(CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight));
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){.origin = origin,.size = layoutAttributes.frame.size};
        }
    }
    return answer;
}
    
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound{
    return YES;
}

@end
