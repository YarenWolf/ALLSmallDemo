//
//  LocalPlayViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "LocalPlayViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@interface Utils : NSObject
+(UIImage *)getArtworkByPath:(NSString *)path;
+(NSMutableDictionary*)getMusicInfoByPath:(NSString *)directoryPath;
@end
@implementation Utils
//获取专辑封面
+(UIImage *)getArtworkByPath:(NSString *)path{
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            if ([metadataItem.commonKey isEqualToString :@"artwork"]) {
                NSData *data = [(NSDictionary*)metadataItem.value objectForKey:@"data"];
                return [UIImage imageWithData:data];break;
            }
        }
    }return nil;
}
//获取歌曲信息
+(NSMutableDictionary*)getMusicInfoByPath:(NSString *)directoryPath{
    NSURL * fileURL=[NSURL fileURLWithPath:directoryPath];
    NSString *fileExtension = [[fileURL path] pathExtension];
    if ([fileExtension isEqual:@"mp3"]||[fileExtension isEqual:@"m4a"]){
        AudioFileID fileID  = nil;
        OSStatus err = noErr;
        err = AudioFileOpenURL( (__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileID );
        if( err != noErr ) {NSLog( @"AudioFileOpenURL failed" );}
        UInt32 id3DataSize  = 0;
        err = AudioFileGetPropertyInfo( fileID,   kAudioFilePropertyID3Tag, &id3DataSize, NULL );
        if( err != noErr ) {NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );}
        NSDictionary *piDict = nil;
        UInt32 piDataSize   = sizeof( piDict );
        err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
        if( err != noErr ) {NSLog( @"AudioFileGetProperty failed for property info dictionary" );}
        UInt32 picDataSize = sizeof(picDataSize);
        err =AudioFileGetProperty( fileID,   kAudioFilePropertyAlbumArtwork, &picDataSize, nil);
        if( err != noErr ) {NSLog( @"Get picture failed" );}
        NSString * Album = [(NSDictionary*)piDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Album]];
        NSString * Artist = [(NSDictionary*)piDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
        NSString * Title = [(NSDictionary*)piDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Title]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (Title) {[dic setObject:Title forKey:@"Title"];}
        if (Artist) {[dic setObject:Artist forKey:@"Artist"];}
        if (Album) {[dic setObject:Album forKey:@"Album"];}
        NSLog(@"%@ %@ %@",Title,Artist,Album);
        return dic;
    }return nil;
}
@end
@interface LocalPlayViewController ()
@property (strong, nonatomic) UISlider *volumeSlider;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (nonatomic, strong)AppDelegate *app;
@property (strong, nonatomic) UISlider *mySlider;

@property (strong, nonatomic) UIImageView *artworkIV;
@property (strong, nonatomic) UISegmentedControl *playModeSC;
@property (strong, nonatomic) UILabel *currentTimeLabel;

@property (nonatomic, strong)NSTimer *timer;
@end
@implementation LocalPlayViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.app = [[UIApplication sharedApplication]delegate];
    self.volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 64, 200, 30)];
    [self.volumeSlider addTarget:self action:@selector(volumeChangeAction:) forControlEvents:UIControlEventValueChanged];
    self.mySlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
    [self.mySlider addTarget:self action:@selector(progressSliderChange:) forControlEvents:UIControlEventValueChanged];
    self.artworkIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 300, 100)];
    self.playModeSC = [[UISegmentedControl alloc]initWithItems:@[@"",@"",@""]];
    [self.playModeSC addTarget:self action:@selector(playModeChanged:) forControlEvents:UIControlEventValueChanged];
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 200, 20)];
    UIButton *pre = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 100, 30)];
    UIButton *play = [[UIButton alloc]initWithFrame:CGRectMake(110, 300, 100, 30)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(210, 300, 100, 30)];
    [pre setTitle:@"" forState:UIControlStateNormal];
    [play setTitle:@"" forState:UIControlStateNormal];
    [next setTitle:@"" forState:UIControlStateNormal];
    pre.backgroundColor = play.backgroundColor = next.backgroundColor = [UIColor redColor];
    [pre addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [play addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    pre.tag = 0;play.tag = 1;next.tag=2;
    [self.view addSubview:self.volumeSlider];
    [self.view addSubview:self.mySlider];
    [self.view addSubview:_artworkIV];
    [self.view addSubview:_playModeSC];
    [self.view addSubview:self.currentTimeLabel];
    [self.view addSubview:pre];
    [self.view addSubview:play];
    [self.view addSubview:next];
    
    //取出播放模式
    self.playModeSC.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"playmode"];
    [self playMusic];
    //    开启timer不停的改变当前时间 和mySlider的Value
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    //获取文件夹下所有内容
    //      [NSFileManager defaultManager]contentsOfDirectoryAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>
    
}

-(void)playMusic{
    if (self.currentIndex==self.musicPaths.count) {
        self.currentIndex = 0;
    }
    if (self.currentIndex==-1) {
        self.currentIndex = self.musicPaths.count-1;
    }
    self.musicPath = self.musicPaths[self.currentIndex];
    //NSURL表示路径 本地或网络
    NSURL *fileURL = [NSURL fileURLWithPath:self.musicPath];
    self.title = [self.musicPath lastPathComponent];
    //判断如果将要播放的和正在播放的是同一首歌的话 什么都不做 接着播放
    if (![self.app.player.url.path isEqualToString:self.musicPath]) {
        //    播放暂停音乐
        self.app.player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    }
    [self.app.player play];
    self.app.player.delegate = self;
    //总时间显示03:32
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.app.player.duration/60,(int)self.app.player.duration%60];
    
    self.mySlider.maximumValue = self.app.player.duration;
    self.artworkIV.image = [Utils getArtworkByPath:self.musicPath];
}
//歌曲播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.playModeSC.selectedSegmentIndex) {
        case 0:self.currentIndex++;[self playMusic];break;
        case 1:[self.app.player play];break;
        case 2:self.currentIndex = arc4random()%self.musicPaths.count;[self playMusic];break;
        default:break;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}
-(void)updateUI{
    self.mySlider.value = self.app.player.currentTime;
    //当前时间显示03:32
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.app.player.currentTime/60,(int)self.app.player.currentTime%60];
}
- (void)volumeChangeAction:(id)sender {
    self.app.player.volume = self.volumeSlider.value;
}
- (void)clicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            if (self.app.player.isPlaying) {
                [self.app.player pause];
                [sender setTitle:@"播放" forState:UIControlStateNormal];
            }else{
                [self.app.player play];
                [sender setTitle:@"暂停" forState:UIControlStateNormal];
            }
            break;
        case 1://上一曲
            self.currentIndex--;
            //    如果是随机 就随机一个index
            if (self.playModeSC.selectedSegmentIndex==2) {
                self.currentIndex = arc4random()%self.musicPaths.count;
            }
            [self playMusic];
            break;
            
        case 2://下一曲
            self.currentIndex++;
            //    如果是随机 就随机一个index
            if (self.playModeSC.selectedSegmentIndex==2) {
                self.currentIndex = arc4random()%self.musicPaths.count;
            }
            [self playMusic];
            break;
    }
}
- (void)progressSliderChange:(UISlider *)sender {
    self.app.player.currentTime = sender.value;
}
- (void)dealloc{
    NSLog(@"播放页面销毁");
}
- (void)playModeChanged:(UISegmentedControl *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:sender.selectedSegmentIndex forKey:@"playmode"];
    [ud synchronize];
}
@end
