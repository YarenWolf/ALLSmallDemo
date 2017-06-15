//
//  EncryptionViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/14.
//  Copyright © 2017年 Super. All rights reserved.
#import "EncryptionViewController.h"
#import "NSString+Hash.h"
#import <SSKeychain/SSKeychain.h>
#define kLoginUserNameKey       @"LoginUsernameKey"
#define kLoginKeyServiceName    @"LoginKeyService"
@interface EncryptionViewController (){
    UILabel *md5Label;
    UITextField *usernameText;
    UITextField *pwdText;
}
@end
@implementation EncryptionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    usernameText = [[UITextField alloc]initWithFrame:CGRectMake(10, TopHeight, APPW-20, 30)];
    pwdText = [[UITextField alloc]initWithFrame:CGRectMake(10, YH(usernameText)+10, W(usernameText), 30)];
    md5Label = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, APPW-40, 80)];
    md5Label.numberOfLines = 0;
    md5Label.text = @"userName:\npassWord: ";
    usernameText.placeholder = @"userName:";
    pwdText.placeholder = @"password:";
    UIButton *login = [[UIButton alloc]initWithFrame:CGRectMake(10, YH(pwdText)+10, APPW-20, 30)];
    [login setTitle:@"登陆" forState:UIControlStateNormal];
    login.backgroundColor = redcolor;usernameText.backgroundColor = pwdText.backgroundColor = [UIColor greenColor];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubviews:usernameText,pwdText,md5Label,login,nil];
    NSLog(@"%@", [SSKeychain allAccounts]);
    // 读取用户偏好信息
    usernameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserNameKey];
    // 读取账户信息
    NSString *pwd = [SSKeychain passwordForService:kLoginKeyServiceName account:usernameText.text];
    pwdText.text = pwd;
    // 删除钥匙串
    [SSKeychain deletePasswordForService:kLoginKeyServiceName account:@"zhangsan"];
    
    
    
    // 读取cookie
    NSLog(@"%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@", cookie.properties);
        if ([[cookie name] isEqualToString:@"userName"]) {
            NSLog(@"用户名 %@", [cookie value]);
        } else if ([[cookie name] isEqualToString:@"userPassword"]) {
            NSLog(@"密码 %@", [cookie value]);
        }
    }
    
}
- (void)login {
    NSString *username = usernameText.text;
    NSString *pwd = [pwdText.text md5String];
    md5Label.text = [NSString stringWithFormat:@"userName:%@\npassWord:%@",username,pwd];
    NSURL *url = [NSURL URLWithString:[kLoginKeyServiceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", username, pwd];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        //获取cookies
        NSLog(@"%@ %@", response, [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
        
        
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:kLoginUserNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //保存到钥匙串
        [SSKeychain setPassword:pwdText.text forService:kLoginKeyServiceName account:usernameText.text];
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kLoginUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SSKeychain setPassword:pwdText.text forService:kLoginKeyServiceName account:usernameText.text];
}

@end
