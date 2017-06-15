//
//  TRXMPPManager.m
//  Day20XMPP
//
//  Created by tarena on 14-12-25.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import "TRXMPPManager.h"
static TRXMPPManager *_manager;
@implementation TRXMPPManager

+(TRXMPPManager *)shareManager{
    if (!_manager) {
        _manager = [[TRXMPPManager alloc]init];
    }
    
    return _manager;
}


- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)pw
{
    self.password = pw;
    self.xmppStream = [[XMPPStream alloc]init];
    //   设置delegate
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //    设置服务器地址 172.60.5.100  124.207.192.18
    [self.xmppStream setHostName:@"124.207.192.18"];
    [self.xmppStream setHostPort:5222];
    //    设置当前用户的信息
    NSString *jidName = [NSString stringWithFormat:@"%@@tarena.com",name];
    XMPPJID *myJID = [XMPPJID jidWithString:jidName];
    [self.xmppStream setMyJID:myJID];
    //    连接服务器
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"已经连接");
    //登陆
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"已经断开");
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登陆成功");
    
    //   通知服务器登陆状态
    [self.xmppStream sendElement:[XMPPPresence presence]];
    
//    初始化花名册对象
    XMPPRosterCoreDataStorage *storage = [[XMPPRosterCoreDataStorage alloc]init];
    
    self.roster = [[XMPPRoster alloc]initWithRosterStorage:storage];
// 激活花名册
    [self.roster activate:self.xmppStream];
    
    [self queryFriends];
}


-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登陆失败");
    //    注册
    [self.xmppStream registerWithPassword:self.password error:nil];
}

-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功！");
    
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败 ：%@",error);
}

-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    [self.delegate didReceiveMessage:message];
    
}

- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type{
    
    XMPPMessage *message = [XMPPMessage messageWithType:type to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@tarena.com",toName]]];
    [message addBody:body];
    
    [self.xmppStream sendElement:message];
    return message;
}

//发出获得好友列表请求
- (void)queryFriends {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

//接收到服务器返回的好友列表时调用此方法
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *name = [item attributeStringValueForName:@"jid"];
                NSLog(@"name--%@",name);
                //把得到的好友名称传递到Controller里面
                [self.delegate didReceiveFirendName:name];
                
                
            }
        }
    }
    
    return YES;
}

-(void)addFriendByName:(NSString *)name{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@tarena.com",name]];
    //添加好友
    [self.roster addUser:jid withNickname:name];
}
-(void)deleteFriendByName:(NSString *)name{
     XMPPJID *jid = [XMPPJID jidWithString:name];
    [self.roster removeUser:jid];
    
}




@end
