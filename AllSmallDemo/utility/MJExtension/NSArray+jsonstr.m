//
//  NSArray+jsonstr.m
//  json
//
//  Created by home on 15/11/23.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import "NSArray+jsonstr.h"
#import "WDExtension.h"
@implementation NSArray (jsonstr)
-(NSString*)jsonStr{
    NSMutableString*mstr=[NSMutableString new];
    
    [mstr appendString:@"[\n"];
    
    for (id obj in self) {
        if ([obj isEqual:self.lastObject]) {
            [mstr appendString:[NSString stringWithFormat:@"%@\n",[self strfrome:obj]]];
        }else{
        
        [mstr appendString:[NSString stringWithFormat:@"%@,\n",[self strfrome:obj]]];
        
        }
    }
    [mstr appendString:@"]"];

    return mstr;

}

-(NSString*)strfrome:(id)obj{
    
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)obj jsonStr];
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\"",obj];
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return [(NSArray*)obj jsonStr];
    }
    
    
    return [[obj wkeyValues] jsonStr];
    
}
-(NSString *)jsonStrSYS{

    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}
@end
