//
//  labList.m
//  最美应用(展示部分)
//
//  Created by 阿城 on 15/11/12.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "labList.h"
@interface labCell : UICollectionViewCell
@property (nonatomic ,weak) UIImageView *imgView;
@end
@implementation labCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"button_white_normal"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height *0.5, image.size.width *0.5, image.size.height *0.5, image.size.width *0.5) ];
        imgView.image = image;
        imgView.frame = CGRectMake(0, self.bounds.size.height * 0.5 - 10, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:imgView];
        _imgView = imgView;
    }return self;
}
@end
@interface labList ()<UICollectionViewDataSource,UICollectionViewDelegate>
@end
@implementation labList
-(instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 2.5, 0, 2.5);
//    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(45, frame.size.height);
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[labCell class] forCellWithReuseIdentifier:@"cell"];
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        //添加手势
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longP:)];
        longP.minimumPressDuration = 0;
        [self addGestureRecognizer:longP];
    }return self;
}
-(void)longP:(UITapGestureRecognizer *)sender{
//    NSLog(@"longP");
    CGPoint point = [sender locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
    NSArray *arr = [self visibleCells];
    for (labCell *cell in arr) {
        if (CGRectContainsPoint(cell.frame, point)) {
            NSIndexPath *idx = [self indexPathForCell:cell];
            int num = idx.item;
            //前部分
            for (int i = num - 4; i< num + 5 ; i++) {
                if (i < 0 || i >= _dataArr.count) {
                    continue;
                }
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
                labCell *subCell = (labCell *)[self cellForItemAtIndexPath:indexpath];
                [UIView animateWithDuration:0.25 animations:^{
                    subCell.transform = CGAffineTransformMakeTranslation(0, -40 + 10*ABS(i-num));
                } ];
            }break;
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (labCell *cell in arr) {
            if (CGRectContainsPoint(cell.frame, point)) {
                NSIndexPath *idx = [self indexPathForCell:cell];
                [self changeLabWithIndexpath:idx];
                if(self.didSelectIndex){
                    self.didSelectIndex(idx);
                }
            }
        }
    }
}
-(void)selectLabWithIndexpath:(NSIndexPath *)idx{
    [self scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self changeLabWithIndexpath:idx];
}
-(void)changeLabWithIndexpath:(NSIndexPath *)idx{
    for (int i = 0; i< self.subviews.count; i++){
        labCell *cell = (labCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGAffineTransform trans ;
        if (i == idx.item) {
            trans = CGAffineTransformMakeTranslation(0, -40);
        }else{
            trans = CGAffineTransformIdentity;
        }
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
            cell.transform = trans;
        } completion:nil];
    }
}
#pragma mark  UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    labCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

@end
