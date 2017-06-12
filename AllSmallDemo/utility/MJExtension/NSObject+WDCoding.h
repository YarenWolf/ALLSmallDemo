//
//  NSObject+WDCoding.h
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WDCoding)
/**
 *  解码（从文件中解析对象）
 */
- (void)decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define WDCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}