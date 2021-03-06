//
//  MediaPlayViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "MediaPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface HMAudioTool : NSObject
+ (void)playAudioWithFilename:(NSString  *)filename;
+ (void)disposeAudioWithFilename:(NSString  *)filename;
@end
@implementation HMAudioTool
static NSMutableDictionary *_soundIDs;
+ (NSMutableDictionary *)soundIDs{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }return _soundIDs;
}
+ (void)playAudioWithFilename:(NSString *)filename{
    if (filename == nil) {return;}
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (!soundID) {
        NSLog(@"创建新的soundID");
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) {return;}
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [self soundIDs][filename] = @(soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}
+ (void)disposeAudioWithFilename:(NSString *)filename{
    if (filename == nil) {return;}
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [[self soundIDs] removeObjectForKey:filename];
    }
}
@end

@interface MediaPlayViewController ()
@property (strong, nonatomic) UISegmentedControl *choosePlay;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *layer;
@property(nonatomic,strong)MPMoviePlayerController *localPlayer;
@end
@implementation MediaPlayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.choosePlay = [[UISegmentedControl alloc]initWithItems:@[@"音频",@"视频"]];
    self.choosePlay.frame = CGRectMake(10, TopHeight,APPW-20, 30);
    self.choosePlay.selectedSegmentIndex = 0;
    UIButton *play = [[UIButton alloc]initWithFrame:CGRectMake(10, TopHeight+50, 100, 30)];
    play.backgroundColor = redcolor;
    [play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [play setTitle:@"播放" forState:UIControlStateNormal];
    UIButton *pause = [[UIButton alloc]initWithFrame:CGRectMake(150, TopHeight+50, 100, 30)];
    pause.backgroundColor = redcolor;
    [pause addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [pause setTitle:@"暂停" forState:UIControlStateNormal];
    UIButton *continueplay = [[UIButton alloc]initWithFrame:CGRectMake(280, TopHeight+50, 100, 30)];
    continueplay.backgroundColor = redcolor;
    [continueplay addTarget:self action:@selector(continuePlay:) forControlEvents:UIControlEventTouchUpInside];
    [continueplay setTitle:@"继续播放" forState:UIControlStateNormal];
    [self.view addSubviews:self.choosePlay,play,pause,continueplay,nil];
    UIButton *sound1 = [[UIButton alloc]initWithFrame:CGRectMake(10, YH(play)+10, APPW/3, 30)];
    sound1.backgroundColor = redcolor;
    [sound1 setTitle:@"音效播放1" forState:UIControlStateNormal];
    UIButton *sound2 = [[UIButton alloc]initWithFrame:CGRectMake(XW(sound1)+10, YH(play)+10, APPW/3, 30)];
    sound2.backgroundColor = redcolor;
    [sound2 setTitle:@"音效播放2" forState:UIControlStateNormal];
    [sound1 addTarget:self action:@selector(playSound1) forControlEvents:UIControlEventTouchUpInside];
    [sound2 addTarget:self action:@selector(playSound2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubviews:sound1,sound2,nil];
    UIButton *playLocal = [[UIButton alloc]initWithFrame:CGRectMake(10, YH(sound1)+10, 200, 30)];
    [playLocal setTitle:@"播放本地视频" forState:UIControlStateNormal];
    playLocal.backgroundColor = redcolor;
    [playLocal addTarget:self action:@selector(playLocalVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playLocal];
    UIButton *jieping = [[UIButton alloc]initWithFrame:CGRectMake(XW(playLocal)+20, Y(playLocal), 100, 30)];
    [jieping setTitle:@"截屏本地" forState:UIControlStateNormal];
    jieping.backgroundColor = redcolor;
    [jieping addTarget:self action:@selector(jieping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jieping];
}
-(void)playLocalVideo{
    
    NSString *path = @"/Users/tarena/Desktop/开讲大时代——林丹：没有人想永远输给你.mp4";
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    self.localPlayer = [[MPMoviePlayerController alloc]initWithContentURL:fileURL];
    self.localPlayer.view.frame = CGRectMake(0, 0, 320, 200);
    [self.view addSubview:self.localPlayer.view];
    [self.localPlayer setControlStyle:MPMovieControlStyleNone];
    [self.localPlayer play];
    
    //监听获取缩略图的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
}
-(void)jieping{
     [self.localPlayer requestThumbnailImagesAtTimes:@[@(self.localPlayer.currentPlaybackTime)] timeOption:MPMovieTimeOptionExact];
}
-(void)imageDidFinish:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    UIImage *image = [noti.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, 320, 200)];
    iv.image = image;
    [self.view addSubview:iv];
    
}
-(void)playSound1{
    [HMAudioTool playAudioWithFilename:@"buyao.wav"];
}
-(void)playSound2{
    [HMAudioTool playAudioWithFilename:@"a.wav"];
}
- (void)didReceiveMemoryWarning{
    [HMAudioTool disposeAudioWithFilename:@"buyao.wav"];
}
- (void)play:(UIButton *)sender {
    //音频接口
    NSString *audioPath = @"http://fdfs.xmcdn.com/group1/M00/01/3B/wKgDrVCYca7Sf6VzADfjEnQrWdU600.mp3";
    //    视频接口
    NSString *videoPath = @"http://flv2.bn.netease.com/videolib3/1510/25/bIHxK3719/SD/bIHxK3719-mobile.mp4";
    switch (_choosePlay.selectedSegmentIndex) {
        case 0:
            [self.layer removeFromSuperlayer];
            self.player = [AVPlayer playerWithURL:[NSURL URLWithString:audioPath]];
            
            break;
        case 1:
            [self.layer removeFromSuperlayer];
            self.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoPath]];
            self.layer = [AVPlayerLayer playerLayerWithPlayer:_player];
            self.layer.frame = CGRectMake(0, 200,APPW, 300);
            [self.view.layer addSublayer:_layer];
            break;
        default:
            break;
    }
    [self.player play];
}
- (void)pause:(UIButton *)sender {
    [self.player pause];
}
- (void)continuePlay:(UIButton *)sender {
    [self.player play];
}

@end
