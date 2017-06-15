//
//  TRXMPPManager.h
//  Day20XMPP
//
//  Created by tarena on 14-12-25.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@protocol TRXMPPManagerDelegate <NSObject>

-(void)didReceiveMessage:(XMPPMessage*)message;

-(void)didReceiveFirendName:(NSString *)name;

@end

@interface TRXMPPManager : NSObject
@property (nonatomic, weak)id<TRXMPPManagerDelegate> delegate;
@property (nonatomic, strong)XMPPStream *xmppStream;
@property (nonatomic, strong)NSString *password;
//花名册对象
@property (nonatomic, strong)XMPPRoster *roster;

+(TRXMPPManager *)shareManager;
-(void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)pw;
- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type;

- (void)addFriendByName:(NSString *)name;
-(void)deleteFriendByName:(NSString *)name;
//查询好友列表
- (void)queryFriends;
@end

