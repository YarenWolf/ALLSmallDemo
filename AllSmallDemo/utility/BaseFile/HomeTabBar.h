//
//  HomeTabBar.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTabBar;
@protocol HomeTabBarDelegate <UITabBarDelegate>
-(void)MyTabBarDidClickCenterButton:(HomeTabBar*)tabBar;

@end
@interface HomeTabBar : UITabBar
@property(nonatomic,weak)id<HomeTabBarDelegate>delegate;
@end
