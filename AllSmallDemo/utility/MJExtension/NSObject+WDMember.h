//
//  NSObject+WDMember.h
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDIvar.h"
#import "WDMethod.h"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^WDClassesBlock)(Class c, BOOL *stop);

@interface NSObject (WDMember)

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(WDIvarsBlock)block;

/**
 *  遍历所有的方法
 */
- (void)enumerateMethodsWithBlock:(WDMethodsBlock)block;

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(WDClassesBlock)block;
@end
