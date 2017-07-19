//
//  GameEngine.h
//  QFFlyBird游戏
//
//  Created by huangdl on 14-8-27.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerElement : NSObject

@property (nonatomic,copy) void(^callback)();
@property (nonatomic,assign) int timerSpace;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL isValid;

@end




@interface GameEngine : NSObject

+(id)sharedEngine;

/**
 *  在当前的引擎里面,注册一个事件
 *
 *  @param callback 回调方法
 *  @param time     每隔多长时间,这个回调方法执行一次
 *  @param name     注册的回调方法的名字key
 */
-(void)regTimerAction:(void(^)())callback withTime:(int)time withName:(NSString *)name;

-(void)setValid:(BOOL)valid withName:(NSString *)name;

-(void)over;

-(void)restart;

@end









