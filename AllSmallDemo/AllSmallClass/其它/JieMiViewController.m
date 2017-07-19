//
//  JieMiViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/7/19.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "JieMiViewController.h"
#import "CRCrypto.h"
#import "SSZipArchive.h"
@interface JieMiViewController ()
@end
@implementation JieMiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[[UIDevice currentDevice].identifierForVendor UUIDString]);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    CRCrypto *crypto = [[CRCrypto alloc] init];
    // encrypt
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"100" ofType:@"zip"];
    //    NSData *zipData = [[NSData alloc] initWithContentsOfFile:filePath];
    //    NSData *encryptData = [crypto AESEecryptWithKey:@"1234567890123456" data:zipData];
    //    NSString *encryptZipFilePath = [documentPath stringByAppendingPathComponent:@"100-encrypt.zip"];
    //    [encryptData writeToFile:encryptZipFilePath atomically:YES];
    //    NSString *newDecryptFilePath = [documentPath stringByAppendingPathComponent:@"100-decrypt.zip"];
    //    NSData *decryptData = [crypto AESDecryptWithKey:@"1234567890123456" data:encryptData];
    //    [decryptData writeToFile:newDecryptFilePath atomically:YES];
    //    NSString *md5 = [[CRCrypto md5:@"abcd"] lowercaseString];
    
    NSString *fileName = @"59_ffrktd.zip";
    NSString *keyA = @"1234@019DEES&^#1fd";
    NSString *keyB = @"bfcfd9fd6291";
    NSString *originKey = [NSString stringWithFormat:@"%@%@%@",fileName,keyA,keyB];
    NSString *md5Key = [[CRCrypto md5:originKey] lowercaseString];
    NSString *finalKey = [md5Key substringWithRange:NSMakeRange(0, 16)];
    NSString *path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    NSString *decryptFilePath = [documentPath stringByAppendingPathComponent:fileName];
    //    NSData *zipData = [[NSData alloc] initWithContentsOfFile:path];
    unsigned long long bufferSize = 1024 * 1024 - kCCBlockSizeAES128;
    //    unsigned long long bufferSize = kCCContextSizeAES128;
    NSFileHandle *readFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    [[NSFileManager defaultManager] createFileAtPath:decryptFilePath contents:nil attributes:nil];
    NSFileHandle *writeFileHandle = [NSFileHandle fileHandleForWritingAtPath:decryptFilePath];
    
    while (YES) {
        @autoreleasepool {
            NSData *buffer = [readFileHandle readDataOfLength:bufferSize];
            NSLog(@"buffer length %d",buffer.length);
            if (buffer.length == 0) {
                break;
            }
            
            NSData *newData = [crypto AESDecryptWithKey:finalKey data:buffer];
            NSLog(@"write length %d",newData.length);
            [writeFileHandle writeData:newData];
        }
    }
    
    [readFileHandle closeFile];
    [writeFileHandle closeFile];
    
    NSString *dirPath = [documentPath stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
    
    
    
    
    
    BOOL result = [SSZipArchive unzipFileAtPath:decryptFilePath toDestination:dirPath];
    //    NSString *unzipFilePath = [documentPath stringByAppendingPathComponent:@"temp"];
    NSLog(@"%@",decryptFilePath);
    NSLog(@"unzip result : %d",result);
    
    if (result) {
        
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
        NSLog(@"unzip files : %@",files);
        NSString *infoPath = [dirPath stringByAppendingPathComponent:@"info.json"];
        NSData *infoData = [NSData dataWithContentsOfFile:infoPath];
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"-----------info--------------------");
        NSLog(@"%@",info);
        
        long updatetime = [[info objectForKey:@"updateTime"] longValue];
        NSLog(@"----------data test----------------");
        NSString *jsonDataPath = [dirPath stringByAppendingPathComponent:@"data"];
        NSArray *jsonDatas = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:jsonDataPath error:nil];
        
        //        NSData *firstJsonData = jsonDatas.firstObject;
        NSString *jsonDataKey = [NSString stringWithFormat:@"%@%@%@",jsonDatas.firstObject,keyA,[NSNumber numberWithLong:updatetime]];
        
        NSString *firstJsonPath = [jsonDataPath stringByAppendingPathComponent:jsonDatas.firstObject];
        NSData *firstJsonData = [NSData dataWithContentsOfFile:firstJsonPath];
        NSData *decryptFirstJsonData = [crypto AESDecryptWithKey:[self md516Key:jsonDataKey] data:firstJsonData];
        NSDictionary *firstJson = [NSJSONSerialization JSONObjectWithData:decryptFirstJsonData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",firstJson);
        
        NSLog(@"------------audio test--------------");
        NSString *audioPath = [dirPath stringByAppendingPathComponent:@"audio"];
        NSArray *audios = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:audioPath error:nil];
        if (audios.count > 0) {
            NSString *audioKey = [NSString stringWithFormat:@"%@%@%@",audios.firstObject,keyA,[NSNumber numberWithLong:updatetime]];
            NSString *firstAudioPath = [audioPath stringByAppendingPathComponent:audios.firstObject];
            NSData *audioData = [NSData dataWithContentsOfFile:firstAudioPath];
            NSData *decryptAudioData = [crypto AESDecryptWithKey:[self md516Key:audioKey] data:audioData];
            NSString *decryptAudioPath = [audioPath stringByAppendingPathComponent:@"decrypt.mp3"];
            [decryptAudioData writeToFile:decryptAudioPath atomically:YES];
            
            NSLog(@"decryptAudioPath:%@",decryptAudioPath);
        }
    }
    //    BOOL result = [SSZipArchive unzipFileAtPath:decryptFilePath toDestination:unzipFilePath];
    //    NSLog(@"%d",result);
}
- (NSString *)md516Key:(NSString *)origin{
    NSString *md5Key = [[CRCrypto md5:origin] lowercaseString];
    return [md5Key substringWithRange:NSMakeRange(0, 16)];
}
@end

