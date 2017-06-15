//
//  ScrollPageViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "ScrollPageViewController.h"
#import "REPagedScrollView.h"

@implementation ScrollPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(20, TopHeight+20, APPW-40, APPH-TopHeight- 40)];
    test.backgroundColor = [UIColor lightGrayColor];
    [scrollView addPage:test];
    
    test = [[UIView alloc] initWithFrame:CGRectMake(20, TopHeight+ 20,  APPW-40, APPH-TopHeight - 40)];
    test.backgroundColor = [UIColor blueColor];
    [scrollView addPage:test];
    
    test = [[UIView alloc] initWithFrame:CGRectMake(20, TopHeight+20,  APPW-40,APPH-TopHeight - 40)];
    test.backgroundColor = [UIColor greenColor];
    [scrollView addPage:test];
    
    test = [[UIView alloc] initWithFrame:CGRectMake(20, TopHeight+20,  APPW-40, APPH-TopHeight-40)];
    test.backgroundColor = [UIColor redColor];
    [scrollView addPage:test];
    
    test = [[UIView alloc] initWithFrame:CGRectMake(20, TopHeight+20,  APPW-40, APPH-TopHeight - 40)];
    test.backgroundColor = [UIColor yellowColor];
    [scrollView addPage:test];
    
}

@end

