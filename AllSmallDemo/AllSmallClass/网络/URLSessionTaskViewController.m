//
//  URLSessionTaskViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "URLSessionTaskViewController.h"

@interface URLSessionTaskViewController () <NSURLSessionDownloadDelegate>
@end
@implementation URLSessionTaskViewController
- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self downloadTask2];
}
- (void)downloadTask2{
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/test.mp4"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    [task resume];
}
- (void)downloadTask{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/test.mp4"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSFileManager *mgr = [NSFileManager defaultManager];
        [mgr moveItemAtPath:location.path toPath:file error:nil];
    }];
    [task resume];
}
- (void)dataTask{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://192.168.15.172:8080/MJServer/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=123&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"----%@", dict);
    }];
    [task resume];
}
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    // location : 临时文件的路径（下载好的文件）
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr moveItemAtPath:location.path toPath:file error:nil];
}
//恢复下载时调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    double progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"下载进度---%f", progress);
}


@end

