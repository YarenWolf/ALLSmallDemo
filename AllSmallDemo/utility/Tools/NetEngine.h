//
//  NetEngine.h
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>
#import "SVProgressHUD.h"
#import "NSString+expanded.h"
#import "UIView+expanded.h"
#import "NSDictionary+expanded.h"
@interface NetEngine : AFHTTPSessionManager
typedef void (^ResponseBlock)(id resData,BOOL isCache);
typedef void (^ErrorBlock)(NSError *error);
/**
 *  定义请求成功的block
 */
typedef void(^successBlock)(id responseBody);

typedef void (^ResponseImageBlock) (UIImage* fetchedImage, NSURL* url, BOOL isInCache);
///单例创建对象
+(id)Share;
///普通网络请求get数据
+(NSURLSessionDataTask*) createGetAction:(NSString*)url onCompletion:(ResponseBlock) completion;
///普通网络请求post数据
+(NSURLSessionDataTask*) createPostAction:(NSString*)url withParams:(NSDictionary*)params onCompletion:(ResponseBlock) completion;
///文件下载
+(NSURLSessionTask*) createFileAction:(NSString*) url onCompletion:(ResponseBlock) completionBlock onError:(ErrorBlock) errorBlock withMask:(SVProgressHUDMaskType)mask;
///文件上传@[@{@"fileData":data,@"fileKey":@"image",@"fileName":@"name.jpg"}]
+(NSURLSessionDataTask*) uploadAllFileAction:(NSString*)url withParams:(NSDictionary*)params fileArray:(NSMutableArray *)fileArray onCompletion:(ResponseBlock)completionBlock onError:(ErrorBlock)errorBlock withMask:(SVProgressHUDMaskType)mask;
///清空内存文件
+(void)emptyCacheDefault;
///根据url获取图片数据
+(NSURLSessionDataTask*)imageAtURL:(NSString *)url onCompletion:(ResponseImageBlock) imageFetchedBlock;




+ (NSURLSessionDataTask *)postUrl:(NSString *)urlString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 *  发送get请求
 *
 *  @param url     网络请求的URL
 *  @param params  传一个字典
 *  @param success 请求成功的block
 *  @param failure 请求失败的block
 */
+(void)sendGetUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(ErrorBlock)failure;

/**
 *  发送get请求
 *
 *  @param url     网络请求的URL 这里的URL转码方式跟上面的不一样注意一下
 *  @param params  传一个字典
 *  @param success 请求成功的block
 *  @param failure 请求失败的block
 */
+(void)sendGetByReplacingUrl:(NSString *)url withParams:(NSDictionary *)params success:(successBlock) success failure:(ErrorBlock)failure;


@end
