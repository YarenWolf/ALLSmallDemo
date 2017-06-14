//
//  PainViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "PainViewController.h"
#import "YZPaintView.h"
@interface PainViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) YZPaintView *paintView;
@end
@implementation PainViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, 40)];
    top.backgroundColor = [UIColor grayColor];
    UIButton *clear = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [clear setTitle:@"清除" forState:UIControlStateNormal];
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 40)];
    [back setTitle:@"撤销" forState:UIControlStateNormal];
    UIButton *erazer = [[UIButton alloc]initWithFrame:CGRectMake(160, 0, 70, 40)];
    [erazer setTitle:@"橡皮擦" forState:UIControlStateNormal];
    UIButton *pic = [[UIButton alloc]initWithFrame:CGRectMake(240, 0, 50, 40)];
    [pic setTitle:@"图片" forState:UIControlStateNormal];
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(320, 0, 50, 40)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    save.titleLabel.textColor = [UIColor redColor];
    [top addSubview:clear];
    [top addSubview:back];
    [top addSubview:erazer];
    [top addSubview:pic];
    [top addSubview:save];
    self.paintView = [[YZPaintView alloc]initWithFrame:CGRectMake(0,TopHeight+40, APPW, 500)];
    self.paintView.backgroundColor = [UIColor whiteColor];
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0,TopHeight+ 550, APPW, 100)];
    bottom.backgroundColor = [UIColor grayColor];
    UISlider *fontsize = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 350, 30)];
    fontsize.value = 0.4;
    UIButton *a = [[UIButton alloc]initWithFrame:CGRectMake(10,30,50, 30)];
    a.backgroundColor = [UIColor yellowColor];
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(100, 30, 50, 30)];
    b.backgroundColor = [UIColor redColor];
    UIButton *c = [[UIButton alloc]initWithFrame:CGRectMake(200, 30, 50, 30)];
    c.backgroundColor = [UIColor greenColor];
    [bottom addSubview:fontsize];
    [bottom addSubview:a];
    [bottom addSubview:b];
    [bottom addSubview:c];
    [self.view addSubview:top];
    [self.view addSubview:self.paintView];
    [self.view addSubview:bottom];
    [clear addTarget:self action:@selector(clearScreen:) forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [erazer addTarget:self action:@selector(eraser:) forControlEvents:UIControlEventTouchUpInside];
    [pic addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchUpInside];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [fontsize addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [a addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
    [b addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
    [c addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)valueChange:(UISlider *)sender {
    _paintView.width = sender.value*10;
}
- (void)colorClick:(UIButton *)sender {
    _paintView.color = sender.backgroundColor;
}
- (void)clearScreen:(id)sender {
    // 将画板里面的数组清空，重绘下
    [self.paintView clearScreen];
}
- (void)undo:(id)sender {
    // 将画板数组的最后一个元素
    [self.paintView undo];
}
- (void)eraser:(id)sender {
    // 设置白色的路径
    self.paintView.color = [UIColor whiteColor];
}
- (void)selectPicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)save:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_paintView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [_paintView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    YZHandleImageView *handleV = [[YZHandleImageView  alloc] initWithFrame:self.paintView.frame];
    handleV.image = info[UIImagePickerControllerOriginalImage];
    handleV.block = ^(UIImage *image){
        self.paintView.image = image;
    };
    [self.view addSubview:handleV];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) { // 保存成功
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
}
@end

