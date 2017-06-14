//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CLLockLabel.h"
#import "CLLockView.h"
@interface CoreArchive : NSObject
#pragma mark - 偏好类信息存储
/**
 *  保存普通字符串
 */
+(void)setStr:(NSString *)str key:(NSString *)key;
/**
 *  读取
 */
+(NSString *)strForKey:(NSString *)key;
/**
 *  删除
 */
+(void)removeStrForKey:(NSString *)key;
/**
 *  保存int
 */
+(void)setInt:(NSInteger)i key:(NSString *)key;

/**
 *  读取int
 */
+(NSInteger)intForKey:(NSString *)key;
/**
 *  保存float
 */
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key;
/**
 *  读取float
 */
+(CGFloat)floatForKey:(NSString *)key;
/**
 *  保存bool
 */
+(void)setBool:(BOOL)boolValue key:(NSString *)key;
/**
 *  读取bool
 */
+(BOOL)boolForKey:(NSString *)key;
#pragma mark - 文件归档
/**
 *  归档
 */
+(BOOL)archiveRootObject:(id)obj toFile:(NSString *)path;
/**
 *  删除
 */
+(BOOL)removeRootObjectWithFile:(NSString *)path;
/**
 *  解档
 */
+(id)unarchiveObjectWithFile:(NSString *)path;
@end
@interface NSString (File)
/*
 *  document根文件夹
 */
+(NSString *)documentFolder;
/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder;
/**
 *  生成子文件夹
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *  @param subFolder 子文件夹名
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder;
@end
@implementation NSString (File)
/*
 *  document根文件夹
 */
+(NSString *)documentFolder{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder{
    
    NSString *subFolderPath=[NSString stringWithFormat:@"%@/%@",self,subFolder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:subFolderPath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:subFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return subFolderPath;
}

@end

@implementation CoreArchive

#pragma mark - 偏好类信息存储
//保存普通对象
+(void)setStr:(NSString *)str key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:str forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}

//读取
+(NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

//删除
+(void)removeStrForKey:(NSString *)key{
    
    [self setStr:nil key:key];
    
}

//保存int
+(void)setInt:(NSInteger)i key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setInteger:i forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}

//读取
+(NSInteger)intForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSInteger i=[defaults integerForKey:key];
    
    return i;
}

//保存float
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setFloat:floatValue forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}
//读取
+(CGFloat)floatForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat floatValue=[defaults floatForKey:key];
    
    return floatValue;
}


//保存bool
+(void)setBool:(BOOL)boolValue key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setBool:boolValue forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}
//读取
+(BOOL)boolForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    BOOL boolValue=[defaults boolForKey:key];
    
    return boolValue;
}




#pragma mark - 文件归档
//归档
+(BOOL)archiveRootObject:(id)obj toFile:(NSString *)path{
    return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}
//删除
+(BOOL)removeRootObjectWithFile:(NSString *)path{
    return [self archiveRootObject:nil toFile:path];
}
//解档
+(id)unarchiveObjectWithFile:(NSString *)path{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}








@end



@interface CLLockVC ()

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;


@property (nonatomic,copy) NSString *modifyCurrentTitle;


@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;



/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;



@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
}


/*
 *  事件
 */
-(void)event{
    
    
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
      
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        
        //存储密码
        [CoreArchive setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
        if(_successBlock != nil) _successBlock(self,pwd);
        
        if(CoreLockTypeModifyPwd == _type){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
        //取出本地密码
        NSString *pwdLocal = [CoreArchive strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if(CoreLockTypeVeryfiPwd == _type){
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }else if (CoreLockTypeModifyPwd == _type){//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type) {
                if(_successBlock != nil) _successBlock(self,pwd);
            }
            
        }else{//密码不一致
            
            [self.label showWarnMsg:CoreLockVerifyErrorPwdTitle];

        }
        
        return res;
    };
    
    
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
    
}






/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}







/*
 *  控制器准备
 */
-(void)vcPrepare{

    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeModifyPwd == _type) {
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];

        if(_isDirectModify) return;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    if(![self.class hasPwd]){
        [_modifyBtn removeFromSuperview];
    }
}

-(void)dismiss{
    [self dismiss:0];
}



/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}



/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}








/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    
    return pwd !=nil;
}




/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;
    
    return lockVC;
}





+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}



-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}



/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}




/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}


- (IBAction)forgetPwdAction:(id)sender {

    [self dismiss:0];
    if(_forgetPwdBlock != nil) _forgetPwdBlock();
}


- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}












@end
