//
//  GameEngine.m
//  QFFlyBird游戏
//
//  Created by huangdl on 14-8-27.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "GameEngine.h"

@implementation TimerElement

@end


@implementation GameEngine
{
    NSMutableArray *_timerArray;
    NSMutableDictionary *_timerDic;
    NSTimer *_timer;
}
+(id)sharedEngine
{
    static GameEngine *_e = nil;
    if (!_e) {
        _e = [[GameEngine alloc]init];
    }
    return _e;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timerArray = [[NSMutableArray alloc]init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        _timerDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

static long count = 0;
-(void)timerAction
{
    //count每隔1/60秒++
    count++;
    for (TimerElement *ele in _timerArray) {
        if (ele.isValid && count % ele.timerSpace == 0) {
            ele.callback();
        }
    }
    
}


-(void)regTimerAction:(void (^)())callback withTime:(int)time withName:(NSString *)name
{
    TimerElement *ele = [[TimerElement alloc]init];
    ele.callback = callback;
    ele.timerSpace = time;
    ele.name = name;
    ele.isValid = YES;
    [_timerArray addObject:ele];
    _timerDic[name] = ele;
}

-(void)setValid:(BOOL)valid withName:(NSString *)name
{
    [_timerDic[name] setIsValid:valid];
}

-(void)over
{
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)restart
{
    [_timer setFireDate:[NSDate date]];
}

@end









