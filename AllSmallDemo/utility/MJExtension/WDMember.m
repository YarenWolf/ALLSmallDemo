//
//  WDMember.m
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "WDMember.h"
#import "WDExtension.h"

@implementation WDMember
/**
 *  初始化
 *
 *  @param srcObject 来源于哪个对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject
{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}

- (void)setSrcClass:(Class)srcClass
{
    _srcClass = srcClass;
    
    _srcClassFromFoundation = [NSStringFromClass(srcClass) hasPrefix:@"NS"];
}

WDLogAllIvrs
@end
