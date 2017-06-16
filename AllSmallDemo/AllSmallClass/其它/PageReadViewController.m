//
//  PageReadViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "PageReadViewController.h"
@interface SubViewController : UIViewController
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *str;
@end
@interface SubViewController ()
@end
@implementation SubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = self.str;
}
@end
@interface PageReadViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>{
    UIPageViewController *_pageViewController;
    NSMutableArray *_dataArray;
    NSInteger _index;
}
@end
@implementation PageReadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTxt];
    _index = 0;
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    SubViewController *sub = [SubViewController new];
    sub.str = _dataArray[0];
    sub.currentPage = 0;
    _index = 0;
    [_pageViewController setViewControllers:@[sub] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageViewController.view];//将一个视图控制器的视图加到另一个视图上，要将视图控制器设成全局变量
}

- (void)configTxt {
    _dataArray = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"乡土中国" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    while (str.length > 600) {
        NSString *subStr = [str substringToIndex:600];
        [_dataArray addObject:subStr];
        str = [str substringFromIndex:600];
    }[_dataArray addObject:str];
}
#pragma mark - UIPageViewController协议方法
//第二个参数：当前的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    SubViewController *vc = (SubViewController *)viewController;
    _index = vc.currentPage;
    _index--;
    if (_index < 0) {
        _index = 0;
        return nil;
    }
    SubViewController *sub = [SubViewController new];
    sub.str = _dataArray[_index];
    sub.currentPage = _index;
    return sub;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    SubViewController *vc = (SubViewController *)viewController;
    _index = vc.currentPage;
    _index++;
    if (_index >= _dataArray.count) {
        _index = _dataArray.count - 1;
        return nil;
    }
    SubViewController *sub = [SubViewController new];
    sub.str = _dataArray[_index];
    sub.currentPage = _index;
    return sub;
}
@end
