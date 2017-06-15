//
//  XMPPViewController.h
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "TRXMPPManager.h"
@interface XMPPViewController : UIViewController<TRXMPPManagerDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

-(void)didReceiveMessage:(XMPPMessage *)message;
@property (nonatomic, copy)NSString *toName;

-(void)sendAudioWithPath:(NSString *)path;
@end
