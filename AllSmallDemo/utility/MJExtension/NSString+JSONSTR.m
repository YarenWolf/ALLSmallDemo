//
//  NSString+JSONSTR.m
//  GangFuBao
//
//  Created by 55like on 1/6/16.
//  Copyright © 2016 55like. All rights reserved.
//

#import "NSString+JSONSTR.h"

@implementation NSString (JSONSTR)

-(NSDictionary*)tojsonDictionary{
    
    if (self == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;


}
@end
