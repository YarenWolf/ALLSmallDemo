//
//  NSDictionary+JSONSTR.m
//  json
//
//  Created by home on 15/11/23.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import "NSDictionary+JSONSTR.h"
#import "NSObject+Extention.h"

#import "WDExtension.h"

@implementation NSDictionary (JSONSTR)
-(NSString*)jsonStr{

    NSMutableString*mstr=[NSMutableString new];
    [mstr appendString:@"{\n"];
    
    NSArray*keyArry=[self allKeys];
    for (NSString *keyname in keyArry) {
        if ([keyname isEqual:[keyArry lastObject]]) {
            [mstr appendString:[NSString stringWithFormat:@"\"%@\":%@\n",keyname,[self strfrome:keyname]]];
        }else
        [mstr appendString:[NSString stringWithFormat:@"\"%@\":%@,\n",keyname,[self strfrome:keyname]]];
    
    
    }
    [mstr appendString:@"}\n"];
    
    return mstr;




}
-(NSString*)strfrome:(NSString*)key{
    id hh=[self JsonObjKey:key];
    
    if ([hh isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)hh jsonStr];
    }
    
    if ([hh isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\"",hh];
    }
    if ([hh isKindOfClass:[NSArray class]]) {
        return [(NSArray*)hh jsonStr];
    }
    
    
    return [[hh wkeyValues] jsonStr];
    
}
-(NSString *)jsonStrSYS{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(NSString *)description{
    
    return self.jsonStrSYS;
    
}
@end
