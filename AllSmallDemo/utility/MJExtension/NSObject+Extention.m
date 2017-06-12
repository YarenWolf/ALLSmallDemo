//
//  NSObject+Extention.m
//  JuYan
//
//  Created by 55like on 15/11/4.
//  Copyright (c) 2015年 55like. All rights reserved.
//

#import "NSObject+Extention.h"

@implementation NSObject (Extention)
-(id)JsonObjKey:(NSString*)key{
    
    id dic=self;
    if (![self isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    NSDictionary*dict=dic;
    id value=  [dict objectForKey:key];
    //    id value = [self objectForKey:aKey];
    if (!value||value==[NSNull null]) {
        return @"";
    }else{
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@",value];
        }
        else if([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@""] || [value isEqualToString:@"null"]) {
                return  @"";
            }
        }
        return value;
    }
    //    return value;
}
@end
