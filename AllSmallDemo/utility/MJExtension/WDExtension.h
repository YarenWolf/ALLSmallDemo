//
//  WDExtension.h
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "WDTypeEncoding.h"
#import "NSObject+WDCoding.h"
#import "NSObject+WDMember.h"
#import "NSObject+WDKeyValue.h"
#import "NSObject+Extention.h"
#import "NSDictionary+JSONSTR.h"
#import "NSArray+jsonstr.h"
#import "NSString+JSONSTR.h"
#define WDLogAllIvrs \
- (NSString *)description \
{ \
    return [self wkeyValues].description; \
}
