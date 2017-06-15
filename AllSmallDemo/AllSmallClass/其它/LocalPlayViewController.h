//
//  LocalPlayViewController.h
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@interface LocalPlayViewController : UIViewController<AVAudioPlayerDelegate>
@property (nonatomic, copy)NSString *musicPath;
@property (nonatomic, strong)NSArray *musicPaths;
@property (nonatomic)int currentIndex;
@end
