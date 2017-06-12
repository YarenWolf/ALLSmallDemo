//
//  NetEngine.m
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "NetEngine.h"
#import "AFImageDownloader.h"
#import "SDDataCache.h"
#import "JSONKit.h"
#import "Utility.h"
//#import "DDXML.h"
@implementation NetEngine
static NSString *cacheDirectoryName = nil;
static NSString *baseURL = @"http://www.isolar88.com/app/";
+(id)Share{
    static NetEngine *manager=nil;
    static dispatch_once_t netEngine;
    dispatch_once(&netEngine, ^ {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL] sessionConfiguration:config];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"text/json"  forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];\
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"application/xml",@"text/xml",@"text/html",@"text/javascript", @"application/x-plist",   @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico",@"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheDirectoryName = [paths[0] stringByAppendingPathComponent:@"AFNetKingCache"];
        //创建附件存储目录
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:cacheDirectoryName]) {
            [fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return manager;
}
//FIXME:普通get请求数据
+(NSURLSessionDataTask*) createGetAction:(NSString*)url onCompletion:(ResponseBlock) completion{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[url getURLParameters]];
    NSRange range = [url rangeOfString:@"?"];
    NSString *baseURL = range.length?[url substringToIndex:range.location]:url;
    //    NSMutableString *realURL = [NSMutableString stringWithString:range.length?[url substringToIndex:range.location+1]:url];
    //    for(NSString *ss in dict.allKeys){
    //        [dict setObject:[dict[ss] urlEncodedString] forKey:ss];
    //        [realURL appendFormat:@"%@=%@&",ss,dict[ss]];
    //    }
    //    DLog(@"\n\nbaseURL= %@",realURL);
    NSURLSessionDataTask *task = [[self Share] GET:baseURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        //        NSString *jsonString = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSDictionary *ddd=[jsonString objectFromJSONString];
        completion(responseObject,NO);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];//@"暂无数据"
    }];
    return task;
}

//FIXME:普通post请求数据
+(NSURLSessionDataTask*) createPostAction:(NSString*)url withParams:(NSDictionary*)params onCompletion:(ResponseBlock) completion{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    for(NSString *ss in params.allKeys){
        [dict setObject:[params[ss] urlEncodedString] forKey:ss];
    }
    NSURLSessionDataTask *task = [[self Share]POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        DLog(@"\n\n\n%@\n\n%@",task.currentRequest.URL,responseObject);
        completion(responseObject,NO);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
    return task;
}


//FIXME:下载图片
+ (NSURLSessionDataTask*)imageAtURL:(NSString *)url onCompletion:(ResponseImageBlock) imageFetchedBlock{
    if (url) {
        NSString *picPath =[url rangeOfString:@"http://"].length?url:[NSString stringWithFormat:@"http://www.isolar88.com/%@",url];
        [[AFImageDownloader defaultInstance]downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:picPath]] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
            imageFetchedBlock(responseObject,request.URL,NO);
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
    return nil;
}

//FIXME:文件下载
+(NSURLSessionTask *)createFileAction:(NSString *)url onCompletion:(ResponseBlock)completionBlock onError:(ErrorBlock)errorBlock withMask:(SVProgressHUDMaskType)mask{
    return [[self Share]createFileAction:url onCompletion:completionBlock onError:errorBlock withMask:mask];
}
-(NSURLSessionTask*) createFileAction:(NSString*)url onCompletion:(ResponseBlock) completionBlock onError:(ErrorBlock) errorBlock withMask:(SVProgressHUDMaskType)mask{
    if(mask!=SVProgressHUDMaskTypeNone){[SVProgressHUD showWithMaskType:mask];}
    //  if([url rangeOfString:@"http://"].location==0){}else{url = [NSString stringWithFormat:@"http://www.isolar88.com/app/%@",url];}
    NSString *storeKey=[url md5];
    //如果使用缓存的话就根据url的md5创建的唯一标识找到对应的文件路径。然后……
    id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
    if(storedata){
        NSString *datastring=[[NSString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
        completionBlock([datastring objectFromJSONString],YES);return nil;
    }else{
        [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
    }
    if ([[Utility Share] offline]){[SVProgressHUD dismiss];errorBlock?errorBlock(nil):nil;return nil;}
    if(mask!=SVProgressHUDMaskTypeNone)[SVProgressHUD showWithStatus:@"数据初始化,请稍候..."];
    // 获得临时文件的路径
    NSString *tempFilePath = [cacheDirectoryName stringByAppendingPathComponent:url.lastPathComponent];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSMutableDictionary *newHeadersDict = [[NSMutableDictionary alloc] init];
    NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleNameKey],[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleVersionKey]];
    [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 判断之前是否下载过 如果有下载重新构造Header
    if ([fileManager fileExistsAtPath:tempFilePath]) {
        NSError *error = nil;
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath error:&error]fileSize];if (error) {NSLog(@"获取 %@ 文件的大小失败!\nError:%@", tempFilePath, error);}
        NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
        [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
        request = mutableURLRequest;
    }
    //下载附件
    //[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];//不使用缓存，避免断点续传出现问题
    NSURLSessionTask *task  = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        DLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        dispatch_async(dispatch_get_main_queue(), ^{});
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        if(error)errorBlock?errorBlock(nil):nil;
        else{
            [[SDDataCache sharedDataCache]storeData:[NSData dataWithContentsOfFile:imgFilePath] forKey:storeKey];
            completionBlock([NSData dataWithContentsOfFile:imgFilePath],NO);
        }
        //                [NSOutputStream outputStreamToFileAtPath:@"" append:YES];
    }];
    return task;
}
//FIXME:文件上传
+(NSURLSessionDataTask*) uploadAllFileAction:(NSString*)url withParams:(NSDictionary*)params fileArray:(NSMutableArray *)fileArray onCompletion:(ResponseBlock)completionBlock onError:(ErrorBlock)errorBlock withMask:(SVProgressHUDMaskType)mask{
    return [[self Share]uploadAllFileAction:url withParams:params fileArray:fileArray onCompletion:completionBlock onError:errorBlock withMask:mask];
}
-(NSURLSessionDataTask*) uploadAllFileAction:(NSString*)url withParams:(NSDictionary*)params fileArray:(NSMutableArray *)fileArray onCompletion:(ResponseBlock)completionBlock onError:(ErrorBlock)errorBlock withMask:(SVProgressHUDMaskType)mask{
    
    if ([[Utility Share] offline]){[SVProgressHUD dismiss];errorBlock?errorBlock(nil):nil;return nil;}
    if(mask!=SVProgressHUDMaskTypeNone)[SVProgressHUD showWithMaskType:mask];
    
    NSURLSessionDataTask *task = [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(NSDictionary *file in fileArray){
            [formData appendPartWithFileData:[file objectForKey:@"fileData"] name:[file valueForJSONKey:@"fileKey"] fileName:[file valueForJSONKey:@"fileName"] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        DLog(@"responseData:%@",responseObject);
        if (!responseObject) {errorBlock?errorBlock(nil):nil;
        }else{
            if ([[responseObject valueForJSONKey:@"status"] isEqualToString:@"502"]) {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForJSONKey:@"info"] ];
                [self performSelector:@selector(backLogin) withObject:nil afterDelay:1.0];
                completionBlock(nil,NO);
            }
            completionBlock(responseObject,NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络超时"];errorBlock?errorBlock(nil):nil;
    }];
    return task;
}

+(void)sendGetUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(ErrorBlock)failure
{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetBase GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)sendGetByReplacingUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(ErrorBlock)failure
{
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetBase GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (NSURLSessionDataTask *)postUrl:(NSString *)urlString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *, id))success
                          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return [manager POST:urlString parameters:parameters progress:nil success:success failure:failure];
}
+(void)emptyCacheDefault{
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectoryName error:&error];
    if(error) DLog(@"%@", error);
    error = nil;
    for(NSString *fileName in directoryContents) {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if(error) DLog(@"%@", error);
    }
}
-(void)backLogin{
    [[Utility Share] clearUserInfoInDefault];
//    [[Utility Share] showLoginAlert:YES];
}
@end
/*
 task = [self GET:urlInfo parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:responseObject options:0 error:nil];
 NSString *jsonString=nil;
 NSArray *items = [doc nodesForXPath:@"//soap:Body" error:nil];
 for (DDXMLElement *obj in items) {//循环查询的每条记录
 for(DDXMLNode *node in obj.children){//取得每个字段的值
 for (DDXMLNode *item in node.children) {
 jsonString=item.stringValue;break;
 }
 }
 }
 if (!doc || !items) {[SVProgressHUD showErrorWithStatus:@"数据有误"];errorBlock?errorBlock(nil):nil;
 }else{
 DLog(@"%@",[jsonString objectFromJSONString]);[SVProgressHUD dismiss];
 completionBlock([jsonString objectFromJSONString],NO);
 if (usecache && storeKey) {
 if (!jsonString){
 [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
 }else{
 [[SDDataCache sharedDataCache] storeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
 }
 }
 }
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 }];
 */
