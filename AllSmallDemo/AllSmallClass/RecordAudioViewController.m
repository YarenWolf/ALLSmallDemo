//
//  RecordAudioViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "RecordAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface RecordAudioViewController ()
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong)AVAudioPlayer *player;
@end
@implementation RecordAudioViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *record = [[UIButton alloc]initWithFrame:CGRectMake(10, TopHeight+20, APPW-20, 30)];
    [record setTitle:@"录音" forState:UIControlStateNormal];
    record.backgroundColor = redcolor;
    [record addTarget:self action:@selector(beginAction) forControlEvents:UIControlEventTouchDown];
    [record addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:record];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//    录音格式
    [settings setValue:@(11025.0) forKey:AVSampleRateKey];//    采样率
    [settings setValue:@(2) forKey:AVNumberOfChannelsKey];//    通道数
    [settings setValue:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];//    音频质量
    NSString *path = @"/Users/franklin/Desktop/aaa.caf";
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
    //准备录制
    [self.recorder prepareToRecord];
}
-(void)beginAction{
    [self.recorder record];
}
-(void)endAction{
    [self.recorder stop];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recorder.url error:nil];
    [self.player play];
}

@end
