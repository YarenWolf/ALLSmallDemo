//
//  TabPianoViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/19.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "TabPianoViewController.h"
#import "labList.h"
@interface TabPianoViewController ()
@property (nonatomic ,copy) NSArray *dataArr;
@property (nonatomic ,strong) labList *labView;
@end
@implementation TabPianoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSArray arrayWithObjects:@1,@2,@3,@4,@5,@6,@7,@8,@9,@10, nil];
    self.view.backgroundColor = [UIColor greenColor];
    _labView = [[labList alloc]initWithFrame:CGRectMake(0, APPH - TopHeight-60, APPW, 120)];
    _labView.dataArr = self.dataArr;
    _labView.didSelectIndex = ^(NSIndexPath *index){
        self.view.backgroundColor =[UIColor colorWithHue:arc4random_uniform(256)/255.0 saturation:0.8 brightness:0.8 alpha:0.8];
    };
    [_labView performBatchUpdates:^{
    }completion:^(BOOL finished) {
        [_labView selectLabWithIndexpath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }];
    [self.view addSubview:_labView];
}
@end

