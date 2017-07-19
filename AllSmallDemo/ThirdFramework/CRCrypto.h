//
//  CRCrypto.h
//  CryptoDemo
//
//  Created by 蔡凌 on 2017/7/7.
//  Copyright © 2017年 蔡凌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface CRCrypto : NSObject
- (NSData*)AESEecryptWithKey:(NSString*)key data:(NSData *)sourceData;
- (NSData*)AESDecryptWithKey:(NSString*)key data:(NSData *)sourceData;
+ (NSString *)md5:(NSString *)string;
@end
