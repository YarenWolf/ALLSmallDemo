//
//  BannerMenuView.h
//  Copy91Home
//
//  Created by chen on 14-7-24.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef KGKit_ViewTag_h
#define KGKit_ViewTag_h

#define kNOTIFICATION_REFRESHREWARDWALL  @"NOTIFICATION_REFRESHREWARDWALL"

#define isIpad      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define isIos7      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()

#endif
@interface BannerMenuView : UIView

/*
 *frame设置浮标位置及长宽
 *nWidth设置展出后增加的菜单宽带，可以动态计算传值
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth;

@end
