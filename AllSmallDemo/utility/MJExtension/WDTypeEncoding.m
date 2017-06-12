//
//  WDTypeEncoding.m
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
/**
 *  成员变量类型（属性类型）
 */
#import <Foundation/Foundation.h>
NSString *const WDTypeInt = @"i";
NSString *const WDTypeFloat = @"f";
NSString *const WDTypeDouble = @"d";
NSString *const WDTypeLong = @"q";
NSString *const WDTypeLongLong = @"q";
NSString *const WDTypeChar = @"c";
NSString *const WDTypeBOOL = @"c";
NSString *const WDTypePointer = @"*";

NSString *const WDTypeIvar = @"^{objc_ivar=}";
NSString *const WDTypeMethod = @"^{objc_method=}";
NSString *const WDTypeBlock = @"@?";
NSString *const WDTypeClass = @"#";
NSString *const WDTypeSEL = @":";
NSString *const WDTypeId = @"@";

/**
 *  返回值类型(如果是unsigned，就是大写)
 */
NSString *const WDReturnTypeVoid = @"v";
NSString *const WDReturnTypeObject = @"@";



