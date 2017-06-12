//
//  LoginViewController.m
//  ZhuiKe55like
//
//  Created by junseek on 14-11-19.
//  Copyright (c) 2014年 五五来客 李江. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+expanded.h"
#import "RegisterViewController.h"
#import "FogetKeyViewController.h"
#import "AFNetworking.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>


#define viewH 400
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIButton *refLoginBtn,*refRegistBtn,*refForgetBtn,*refLoginWBbtn,*refLoginQQbtn,*refLoginWXbtn;
@property (nonatomic, weak) IBOutlet UITextField *refPhoneTF,*refPasswdTF;
@property (nonatomic, weak) IBOutlet UIImageView *refPhoneTFBG,*refPasswdTFBG,*refLogo;
@property (nonatomic, weak) IBOutlet UIScrollView *scrolView;
-(IBAction)BtnOnclick:(id)sender;
@end
@implementation LoginViewController
-(void)BtnOnclick:(id)sender{
    if (sender == self.refLoginBtn) {
        //登陆
        if (![[Utility Share] validateTel:_refPhoneTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机好码"];
            return;
        }
        if (![_refPasswdTF.text notEmptyOrNull]) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        if (self.userInfo && [self.userInfo isEqualToString:@"againLogin"]) {
            //
            [[Utility Share] loginWithAccount:_refPhoneTF.text pwd:_refPasswdTF.text];
        }else{
            [[Utility Share]isLoginAccount:_refPhoneTF.text pwd:_refPasswdTF.text aLogin:^(NSInteger NoLogin) {
                if (NoLogin==1)
                {
                    [self goback];
                }
            }];
        }
    }else if (sender == self.refRegistBtn ){
        //注册
        [self pushController:[RegisterViewController class] withInfo:nil withTitle:@"注册"] ;
    }else if(sender == self.refForgetBtn ){
        //忘记密码
        [self pushController:[FogetKeyViewController class] withInfo:nil withTitle:@"忘记密码"];
    }
    else if (sender == self.refLoginWBbtn){
        //微博登陆
        //微博
//        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
//                          authOptions:nil
//                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
//             if (result){
//                 //打印输出用户uid：
//                 NSLog(@"uid = %@",[userInfo uid]);
//                 //打印输出用户昵称：
//                 NSLog(@"name = %@",[userInfo nickname]);
//                 //打印输出用户头像地址：
//                 NSLog(@"icon = %@",[userInfo profileImage]);
//                 [[Utility Share] setUserName:[userInfo nickname]];
//                 [[Utility Share] setUserLogo:[userInfo profileImage]];
//                 [[Utility Share] setUserAccount:[userInfo nickname]];
//                 [[Utility Share] saveUserInfoToDefault];
//                 NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//                 [dic setValue:[userInfo uid] forKey:@"openid"];
//                 [dic setValue:[userInfo nickname] forKey:@"nickname"];
//                 [dic setValue:[userInfo profileImage] forKey:@"icon"];
//                 [dic setValue:@"sina" forKey:@"type"];
//                 [self loginThirdPartyLogin:dic];
//             }else{
//                 [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@",error.errorDescription]];
//                 NSLog(@"**********%@",error.errorDescription);
//             }
//         }];
    }else if (sender == self.refLoginWXbtn){
        //微信登陆
//        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
//        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
//                          authOptions:nil
//                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//         {
//             
//             if (result)
//             {
//                 NSString *iconstr = [userInfo profileImage];
//                 if ([iconstr isEqualToString:@""]) {
//                     iconstr = @"aaaaa";
//                 }
//                 //打印输出用户uid：
//                 NSLog(@"uid = %@",[userInfo uid]);
//                 //打印输出用户昵称：
//                 NSLog(@"name = %@",[userInfo nickname]);
//                 //打印输出用户头像地址：
//                 NSLog(@"icon = %@",[userInfo profileImage]);
//                 
//                 [[Utility Share] setUserName:[userInfo nickname]];
//                 [[Utility Share] setUserLogo:[userInfo profileImage]];
//                 [[Utility Share] setUserAccount:[userInfo nickname]];
//                 [[Utility Share] saveUserInfoToDefault];
//                 
//                 NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//                 [dic setValue:[userInfo uid] forKey:@"openid"];
//                 [dic setValue:[userInfo nickname] forKey:@"nickname"];
//                 [dic setValue:iconstr forKey:@"icon"];
//                 [dic setValue:@"weixin" forKey:@"type"];
//                 [self loginThirdPartyLogin:dic];
//             }else{
//                 [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@",error.errorDescription]];
//             }
//         }];
//        
    }else if(sender == self.refLoginQQbtn){
        //QQ登陆
//        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
//        [ShareSDK getUserInfoWithType:ShareTypeQQSpace
//                          authOptions:nil
//                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
//             
//             if (result){
//                 //打印输出用户uid：
//                 NSLog(@"uid = %@",[userInfo uid]);
//                 //打印输出用户昵称：
//                 NSLog(@"name = %@",[userInfo nickname]);
//                 //打印输出用户头像地址：
//                 NSLog(@"icon = %@",[userInfo profileImage]);
//                 [[Utility Share] setUserName:[userInfo nickname]];
//                 [[Utility Share] setUserLogo:[userInfo profileImage]];
//                 [[Utility Share] setUserAccount:[userInfo nickname]];
//                 [[Utility Share] saveUserInfoToDefault];
//                 NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//                 [dic setValue:[userInfo uid] forKey:@"openid"];
//                 [dic setValue:[userInfo nickname] forKey:@"nickname"];
//                 [dic setValue:[userInfo profileImage] forKey:@"icon"];
//                 [dic setValue:@"qq" forKey:@"type"];
//                 [self loginThirdPartyLogin:dic];
//             }else{
//                 [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@",error.errorDescription]];
//             }
//         }];
    }
}

-(void)loginThirdPartyLogin:(NSDictionary *)dict{
    [[AFHTTPSessionManager manager] POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"resData:%@",[responseObject objectForJSONKey:@"data"]);
        NSDictionary *userDict=[responseObject objectForJSONKey:@"data"];
        [[Utility Share] setUserId:[userDict valueForJSONStrKey:@"uid"]];
        [[Utility Share]  setUserToken:[userDict valueForJSONStrKey:@"token"]];
        [[Utility Share] setUserstatus:[userDict valueForJSONStrKey:@"is_open"]];
        [[Utility Share]  saveUserInfoToDefault];
        [[Utility Share] hiddenLoginAlert];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"againLogin" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(10, 30, 60, 20);
    [backbtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    backbtn.titleLabel.font = fontTitle;
    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_refLoginWBbtn setImage:[UIImage imageNamed:@"share03"] forState:UIControlStateNormal];
    [_refLoginQQbtn setImage:[UIImage imageNamed:@"share05"] forState:UIControlStateNormal];
    [_refLoginWXbtn setImage:[UIImage imageNamed:@"share01"] forState:UIControlStateNormal];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
         _refLoginWXbtn.hidden = NO;
    }else {
        _refLoginWXbtn.hidden = YES;
    }
//    if ([QQApi isQQInstalled]) {
//        //判断是否有qq
//        _refLoginQQbtn.hidden = NO;
//    }else {
//        _refLoginQQbtn.hidden = YES;
//    }
    [backbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.view addSubview:backbtn];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureExec:)];
    [self.view addGestureRecognizer:tapGesture];
    self.refPasswdTF.returnKeyType = UIReturnKeyDone;
    _refPasswdTF.secureTextEntry = YES;
    [self initComponents];
}

- (void)initComponents{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.scrolView setFrame:CGRectMake(0, 64, W(self.view), APPH-64)];
    [self.scrolView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width ,540)];
    self.refLoginBtn.layer.cornerRadius = 20;
    [self.refPhoneTFBG setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    [self.refPasswdTFBG setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] valueForKey:@"guangfubaomobile"];
    _refPhoneTF.text = mobile;
    
    if ([[[Utility Share] userAccount] notEmptyOrNull] && [[[Utility Share] userPwd] notEmptyOrNull]) {
//        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[Utility Share] userAccount],@"mobile",[[Utility Share] userPwd].md5,@"pwd",nil];
//        [NetEngine createHttpAction:@"" withCache:NO withParams:dic withMask:SVProgressHUDMaskTypeNil onCompletion:^(id resData, BOOL isCache) {
//            if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
//                NSDictionary *userDict = [resData objectForJSONKey:@"data"];
//                [[Utility Share] setUserId:[userDict valueForJSONStrKey:@"uid"]];
//                [[Utility Share] setUserToken:[userDict valueForJSONStrKey:@"token"]];
//                [[Utility Share] setUserMobile:[userDict valueForJSONStrKey:@"mobile"]];
//                [[Utility Share] setUserName:[userDict valueForJSONStrKey:@"realname"]];
//                [[Utility Share] setUserLogo:[userDict valueForJSONStrKey:@"photo"]];
//                //[[Utility Share] setUsertype:[userDict valueForJSONStrKey:@"utype"]];
//                [[Utility Share] saveUserInfoToDefault];
//                //            [APService setAlias:[[Utility Share] userId] callbackSelector:@selector(setJpushAlias) object:nil];
//                //            [self performSelector:@selector(WebSocketConnectServer) withObject:nil afterDelay:1.5];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"againLogin" object:nil];
//                [[Utility Share] hiddenLoginAlert];
//            }else{
//                [self hiddenTransitionView];
//            }
//        } onError:^(NSError *error) {
//            [self hiddenTransitionView];
//        }];
    }else{
        //[self performSelector:@selector(hiddenTransitionView) withObject:self afterDelay:4.5];
    }
}
-(void)hiddenTransitionView{
    [[Utility Share] hiddenStartTransitionView];
}

#pragma mark button
-(void)submintButtonClicked{
     [self closeButtonClicked];
//    NSString *strAc=txtAccount.text;
//    NSString *strPwd=txtPwd.text;
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
//    [dict setValue:txtAccount.text forKey:@"mobile"];
//    [dict setValue:txtPwd.text forKey:@"pwd"];
//    [[Utility Share] isLoginAccount:strAc pwd:strPwd  aLogin:^(NSInteger NoLogin) {
//        if (NoLogin==1) {
//            if ([self.userInfo isEqualToString:@"againLogin"]) {
//                [[Utility Share] hiddenLoginAlert];
//            }
//        }
//    }];
    
//    [NetEngine createPostAction:YDuserLogin withParams:dict onCompletion:^(id resData, BOOL isCache) {
//        if ([[resData valueForJSONStrKey:@"status"] isEqualToString:@"200"]) {
//            //成功
//            [SVProgressHUD showSuccessWithStatus:[resData valueForJSONStrKey:@"info"]];
//            NSDictionary *data = [resData valueForJSONKey:@"data"];
//            Utility *ut = [Utility Share];
//            [ut setUserToken:[data objectForKey:@"token"]];
//            [ut setUserId:[data objectForKey:@"id"]];
//            [ut setUserMobile:[data objectForKey:@"mobile"]];
//            [ut setUsertype:[data objectForKey:@"utype"]];
//            [ut saveUserInfoToDefault];
//            [[Utility Share] isLoginAccount:strAc pwd:strPwd  aLogin:^(NSInteger NoLogin) {
//                if (NoLogin==1) {
//                    if ([self.userInfo isEqualToString:@"againLogin"]) {
//                        [[Utility Share] hiddenLoginAlert];
//                    }
//                }
//            }];
//        }else{
//            NSLog(@"错误!");
//            [SVProgressHUD showImage:nil status:[resData valueForJSONStrKey:@"info"]];
//        }
//    }];
    
//    }else{
//        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:strAc,@"tel",strPwd,@"pwd", nil];
//        [self pushController:[LoginYZViewController class] withInfo:self.userInfo withTitle:@"" withOther:dic];
//    }
}
-(void)RegisterButtonClicked{
    [self closeButtonClicked];
//    [self pushController:[RegisterViewController class] withInfo:@"" withTitle:@""];
}
-(void)backPwdButtonClicked{
    [self closeButtonClicked];
//    [self pushController:[BackPasswordViewController class] withInfo:@"" withTitle:@"找回密码"];
    
}

-(void)backbtnAction{
    [[Utility Share] hiddenLoginAlert];
//    [[Utility Share]loginWithAccount:@"12345678910" pwd:@"123456"];
//    [[Utility Share] isLogin:^(NSInteger NoLogin) {
//        if (NoLogin == 1) {
//            [[Utility Share] hiddenLoginAlert];
//        }
//    }];
    
}


#pragma mark - UITextFieldDelegate

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.view.backgroundColor=RGBCOLOR(0 , 97,  167);
    //注册监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark text
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.refPhoneTF) {
        [self.refPasswdTF becomeFirstResponder];
    }else{
        [self submintButtonClicked];
    }
    return YES;
}
-(void)closeButtonClicked{
    [self.refPhoneTF resignFirstResponder];
    [self.refPasswdTF resignFirstResponder];
}
#pragma mark serlector
-(void)handleKeyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"---->动态键盘高度:%f",distanceToMove);
    if (distanceToMove<200) {
        return;
    }
    float t_y=(Y(self.scrolView)+distanceToMove +YH(self.refLoginBtn)+10)-(Version7?APPH:APPH-20);
    NSLog(@"---->动态键盘高度:%f:::::<%f",distanceToMove,t_y);
    [UIView animateWithDuration:0.3 animations:^{
        self.scrolView.frame=CGRectMake(X(self.scrolView), Y(self.scrolView) - t_y, W(self.scrolView),H(self.scrolView));
    }];
}
- (void)handleKeyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrolView.frame=CGRectMake(X(self.scrolView), (APPH-viewH)/2.0, W(self.scrolView),H(self.scrolView));
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//是否支持屏幕旋转
-(BOOL)shouldAutorotate{
    return NO;
}

// 支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskAllButUpsideDown;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(void) tapGestureExec:(UIGestureRecognizer*) gesture {
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        if ([_refPhoneTF canResignFirstResponder]) {
            [_refPhoneTF resignFirstResponder];
        }
        if ([_refPasswdTF canResignFirstResponder]) {
            [_refPasswdTF resignFirstResponder];
        }
    }
}

@end
