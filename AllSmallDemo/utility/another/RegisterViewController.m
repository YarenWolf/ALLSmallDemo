//
//  RegisterViewController.m
//  GuangFuBao
//
//  Created by ios-4 on 15/7/24.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//
#import "RegisterViewController.h"
#import "AFNetworking.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIButton *refYZMBtn,*refRegisBtn,*refFuWuBtn,*refLoginBtn;
@property (nonatomic, weak) IBOutlet UITextField *refPhoneTF,*refMSGTF,*refLoginKeyTF,*refLoginKeyAgainTF;
@property (nonatomic, weak) IBOutlet UILabel *FreeMoney;
@property (nonatomic, weak) IBOutlet  UIImageView *refPhoneTFBG,*refMSGTFBG,*refLoginTFBG,*refLoginTFBG2;
@property (nonatomic, weak) IBOutlet UIScrollView *scrolView;
@property (nonatomic, weak) IBOutlet UIView *refYZMView;
-(IBAction)BtnOnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *agreendview;
@property (weak, nonatomic) IBOutlet UIButton *agreendbtn;
@property (weak, nonatomic) IBOutlet UIImageView *intoimageview;
@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureExec:)];
    [self.view addGestureRecognizer:tapGesture];
    [self loadUI];
}
-(void) loadUI{
    _refPhoneTF.returnKeyType = UIReturnKeyDone;
    _refPhoneTF.delegate = self;
    _refMSGTF.returnKeyType = UIReturnKeyDone;
    _refMSGTF.delegate = self;
    _refLoginKeyTF.returnKeyType = UIReturnKeyDone;
    _refLoginKeyTF.delegate = self;
    _refLoginKeyAgainTF.returnKeyType = UIReturnKeyDone;
    _refLoginKeyAgainTF.delegate = self;
    _intoimageview.hidden = YES;
    [self.scrolView setFrame:CGRectMake(0, 64, W(self.view), APPH-64)];
    [self.scrolView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width ,APPH +1)];
    [self.refPhoneTFBG setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    [self.refMSGTFBG setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    [self.refLoginTFBG setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    [self.refLoginTFBG2 setImage:[[UIImage imageNamed:@"btnBg03"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
    self.refYZMView.layer.cornerRadius = 20;
    self.refRegisBtn.layer.cornerRadius = 20;
    _refLoginKeyTF.secureTextEntry = YES;
    _refLoginKeyAgainTF.secureTextEntry = YES;
}

-(void)BtnOnclick:(id)sender{
    if (sender == self.refYZMBtn) {
        //获取验证码接口
        if ([[Utility Share] validateTel:_refPhoneTF.text]) {
            NSDictionary *dict = @{@"action":@"reg",@"mobile":_refPhoneTF.text};
            [[AFHTTPSessionManager manager] POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
                }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        }
    }else if(sender == self.refRegisBtn){
        //注册接口
        [self.view endEditing:YES];
        if (![[Utility Share] validateTel:_refPhoneTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        if (![_refMSGTF.text notEmptyOrNull]) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        
        if (![_refLoginKeyTF.text isEqualToString:_refLoginKeyAgainTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"登录密码和确认密码不一致"];
            return;
        }
        NSDictionary *dict = @{@"mobile":_refPhoneTF.text,@"pwd":_refLoginKeyAgainTF.text.md5,@"code":_refMSGTF.text};
        [[AFHTTPSessionManager manager] POST:@"" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD showSuccessWithStatus:[responseObject valueForJSONKey:@"info"]];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[Utility Share] loginWithAccount:_refPhoneTF.text pwd:_refLoginKeyAgainTF.text];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }];
    }else if (sender == self.refFuWuBtn){
        //服务条款
        //[self pushController:[regestwebViewController class] withInfo:nil withTitle:@"服务协议条款" withOther:nil];
    }else if (sender == self.refLoginBtn){
        //进入登陆界面
        
    }
}
-(void) tapGestureExec:(UIGestureRecognizer*) gesture {
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        if ([_refPhoneTF canResignFirstResponder]) {
            [_refPhoneTF resignFirstResponder];
        }
        if ([_refMSGTF canResignFirstResponder]) {
            [_refMSGTF resignFirstResponder];
        }
        if ([_refLoginKeyTF canResignFirstResponder]) {
            [_refLoginKeyTF resignFirstResponder];
        }
        if ([_refLoginKeyAgainTF canResignFirstResponder]) {
            [_refLoginKeyAgainTF resignFirstResponder];
        }
    }
}

#pragma mark - textfieldelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - keyboard
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (IBAction)yyzhbtnClick:(UIButton *)sender {
    if (self.otherInfo) {
        [self.navigationController popToRootViewControllerAnimated:NO];
         [[Utility Share]showLoginAlert];
    }else{
        [self goback];
    }
}
-(void)handleKeyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"---->动态键盘高度:%f",distanceToMove);
    [UIView animateWithDuration:0.3 animations:^{
        _scrolView.frame=CGRectMake(X(_scrolView), Y(_scrolView), W(_scrolView),self.view.frame.size.height- Y(_scrolView)-distanceToMove);
    }];
}
- (void)handleKeyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        _scrolView.frame=CGRectMake(0, 64, APPW,APPH-64);
        _scrolView.contentOffset = CGPointMake(0, 0);
        
    }];
}



@end
