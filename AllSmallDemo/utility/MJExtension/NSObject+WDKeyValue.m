//
//  NSObject+WDKeyValue.m
//  WDExtension
//
//  Created by WD on 13-8-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NSObject+WDKeyValue.h"
#import "NSObject+WDMember.h"


@implementation NSObject (WDKeyValue)
#pragma mark - 公共方法
#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        return nil;
        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    
    id model = [[self alloc] init];
    [model setwKeyValues:keyValues];
    return model;
}

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self wobjectWithFile:file];
}

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFile:(NSString *)file
{
    NSDictionary *keyValues = [NSDictionary dictionaryWithContentsOfFile:file];
    return [self wobjectWithKeyValues:keyValues];
}

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (void)setwKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
//        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
        return;
    }
    
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        // 来自Foundation框架的成员变量，直接返回
        if (ivar.isSrcClassFromFoundation) return;
        
        // 1.取出属性值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        id value = keyValues[key];
        if (!value) return;
        
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [ivar.type.typeClass wobjectWithKeyValues:value];
        } else if ([self respondsToSelector:@selector(wobjectClassInArray)]) {
            // 3.字典数组-->模型数组
            Class objectClass = self.wobjectClassInArray[ivar.propertyName];
            if (objectClass) {
                if ([value isKindOfClass:[NSArray class]]) {
                    value = [objectClass wobjectArrayWithKeyValuesArray:value];
                }else return;
                
            }
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *ff=value;
            value =[NSString stringWithFormat:@"%@",ff];
        }
        if (!value||value==[NSNull null]) {
            //            return ;
            value=@"";
        }
        if([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@"null"]) {
                //                return  ;
                value=@"";
//                [value objectForJSONKey:@""];
                
                
            }
        }
        // 4.赋值
        ivar.value = value;
    }];
}

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)wkeyValues
{
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        
        // 1.取出属性值
        id value = ivar.value;
        if (!value) return;
        
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [value wkeyValues];
        } else if ([self respondsToSelector:@selector(wobjectClassInArray)]) {
            // 3.处理数组里面有模型的情况
            Class objectClass = self.wobjectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass wkeyValuesArrayWithObjectArray:value];
            }
        }
        
        // 4.赋值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        keyValues[key] = value;
    }];
    
    return keyValues;
}

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)wkeyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    // 0.判断真实性
    if (![objectArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"objectArray is not a NSArray" format:nil];
    }
    
    // 1.过滤
    if (![objectArray isKindOfClass:[NSArray class]]) return objectArray;
    if (![[objectArray lastObject] isKindOfClass:self]) return objectArray;
    
    // 2.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        [keyValuesArray addObject:[object wkeyValues]];
    }
    return keyValuesArray;
}

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    // 1.判断真实性
    if (![keyValuesArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"keyValuesArray is not a NSArray" format:nil];
    }
    
    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    // 3.遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
        
        id model = [self wobjectWithKeyValues:keyValues];
        [modelArray addObject:model];
    }
    
    return modelArray;
}

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self wobjectArrayWithFile:file];
}

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFile:(NSString *)file
{
    NSArray *keyValuesArray = [NSArray arrayWithContentsOfFile:file];
    return [self wobjectArrayWithKeyValuesArray:keyValuesArray];
}

#pragma mark - 私有方法
/**
 *  根据属性名获得对应的key
 *
 *  @param propertyName 属性名
 *
 *  @return 字典的key
 */
- (NSString *)keyWithPropertyName:(NSString *)propertyName
{
    NSString *key = nil;
    // 1.查看有没有需要替换的key
    if ([self respondsToSelector:@selector(wreplacedKeyFromPropertyName)]) {
        key = self.wreplacedKeyFromPropertyName[propertyName];
    }
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}
-(NSString *)wgetParamStr{
    NSDictionary*dictionary=self.wkeyValues;
    if ([self isKindOfClass:[NSDictionary class]]) {
        id sl=self;
        dictionary =sl;
    }
    
    
    
    NSArray*keyArry=[dictionary allKeys];
    NSMutableString*mstr=[NSMutableString new];
    for (NSString *keyname in keyArry) {
        NSString*value=[dictionary objectForKey:keyname];
        
        if([value isKindOfClass:[NSString class]]){
            if ([keyname isEqual:[keyArry firstObject ]]) {
                [mstr appendFormat:@"?%@=%@",keyname,value];
            }else{
                
                [ mstr appendFormat:@"&%@=%@",keyname,value];
                
            }
        }
    }
    
    
//    1. //字符串加百分号转义使用编码 (这个方法会把参数里面的东西转义)
//    
//    NSString *str1 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    2.//字符串替换百分号转义使用编码
//    
//    NSString *str1 = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return mstr;
    
}
-(void)setWgetParamStr:(NSString *)wgetParamStr{


}
@end
