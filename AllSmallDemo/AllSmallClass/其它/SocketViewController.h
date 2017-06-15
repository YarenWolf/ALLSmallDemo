//
//  SocketViewController.h
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import <AVFoundation/AVFoundation.h>
@interface SocketViewController : UIViewController<AsyncSocketDelegate>
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong)AsyncSocket *serverSocket;
@property (nonatomic, strong)AsyncSocket *clientSocket;
@property (nonatomic, strong)AsyncSocket *myNewSocket;

@end
