//
//  ScreenshotViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "ScreenshotViewController.h"

@interface ScreenshotViewController ()

@end

@implementation ScreenshotViewController
- (void)viewDidLoad{
    [super viewDidLoad];self.view.backgroundColor = redcolor;
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:ctx];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data = UIImagePNGRepresentation(newImage);
        NSString *filePath = [@"/Users/franklin/Desktop" stringByAppendingPathComponent:@"view.png"];
        [data writeToFile:filePath atomically:YES];
//        5.把得到的图片保存到系统相册内 最后一个参数是用来传参的
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(savedPicToPhoto), nil);
    });
}
-(void)savedPicToPhoto{
    NSLog(@"图片保存成功");
}
@end
