
#ifdef DEBUG
 #define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
 #define ELog(err) {if(err) DLog(@"%@", err)}
#else
 #define DLog(...)
 #define ELog(err)
#endif
#define TopHeight         (Version7?64:44)
#define NavY              (Version7?20:0)
#define Boardseperad      10
#define BoldFont(x)       [UIFont boldSystemFontOfSize:x]
#define Font(x)           [UIFont systemFontOfSize:x]
#define appBundleVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]
#define Version7          ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define Version8          ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define NetBase         [AFHTTPSessionManager manager]
#define Net   ({AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];manager.responseSerializer = [AFJSONResponseSerializer serializer];\
manager.requestSerializer=[AFHTTPRequestSerializer serializer];[manager.requestSerializer setValue:@"text/json"  forHTTPHeaderField:@"Accept"];\
[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];\
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"application/xml",\
@"text/xml",@"text/html",@"text/javascript", @"application/x-plist",   @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico",\
@"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];(manager);})
#define HOMEPATH           NSHomeDirectory()//主页路径
#define documentLocalPath      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//Documents路径
#define cachesPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define tempPath           NSTemporaryDirectory()
#define WS(weakSelf)    __weak __typeof(self)weakSelf = self;
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(s)       [UIColor colorFromHex:s]
#define HEXACOLOR(s,a)    [UIColor colorFromHex:s alpha:a]
#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define ApplicationH      [UIScreen mainScreen].applicationFrame.size.height

#define W(obj)            (!obj?0:(obj).frame.size.width)
#define H(obj)            (!obj?0:(obj).frame.size.height)
#define X(obj)            (!obj?0:(obj).frame.origin.x)
#define Y(obj)            (!obj?0:(obj).frame.origin.y)
#define XW(obj)           (X(obj)+W(obj))
#define YH(obj)           (Y(obj)+H(obj))
#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)
#define S2N(x)            [NSNumber numberWithInt:[x intValue]]
#define I2N(x)            [NSNumber numberWithInt:x]
#define F2N(x)            [NSNumber numberWithFloat:x]

///FIXME: 全局变量
#define GLOBALColor    HEXCOLOR(@"#35BE83")
#define TITLEColor     HEXCOLOR(@"#333333")
#define NORMALColor    HEXCOLOR(@"#666666")
#define SMALLColor     HEXCOLOR(@"#999999")
#define LINEColor      HEXCOLOR(@"#CCCCCC")
#define BACKColor      HEXCOLOR(@"#EEEEEE")
#define clearcolor        [UIColor clearColor]
#define gradcolor         RGBACOLOR(224, 225, 226, 1)
#define redcolor          RGBACOLOR(229, 59, 25, 1)
#define yellowcolor       [UIColor yellowColor]
#define whitecolor        RGBACOLOR(256, 256,256,1)
#define blacktextcolor    RGBACOLOR(33, 34, 35, 1)
#define gradtextcolor     RGBACOLOR(116, 117, 118, 1)
#define graycolor         [UIColor grayColor]
#define fontBig           Font(18)
#define fontTitle         Font(16)
#define fontSmallTitle    Font(14)
#define fontnomal         Font(13)
#define fontSmall         Font(12)
#define fontMini          Font(10)

/*******************我的网络资源文件*****************/
#define FileResource(s)   [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
#define APPDelegate       [[UIApplication sharedApplication]delegate]
#define alertErrorTxt     @"服务器异常,请稍后再试"


#define LanguageManager   [HXLanguageManager shareInstance]
#define LocalStr(key, comment) [[HXLanguageManager shareInstance] localizedStringForKey:key value:comment]
///FIXME:用户信息
#define USERACCOUNT @"userAccount"//账号
#define USERID @"userId"//ID
#define USERNAME @"userName"//用户名
#define USERPWD @"userPwd"//密码
#define USERLOGO @"userLogo"//头像
#define USERTOKEN @"userToken"//口令
#define USERADDRESS @"userAddress"//地址
#define USERLONGITUDE @"userlongitude"//经度
#define USERLATITUDE @"userlatitude"//维度
#define USERTYPE @"usertype"//用户级别
#define USERSIGN @"userSign"//用户签名
#define USERMONY @"usermony"//用户金额
#define USERSTATUS @"userstatus"//用户状态
#define USERCARDS @"usercards"//用户银行卡号
#define USERPHONE @"userphone"//手机号
#define USERIDCARD @"useridcard"//身份证号
#define USERWECHARTNUM @"userWechartnum"//微信号
#define USERQQNUMBER @"userQQnumber"//QQ号
#define USERSEX @"userSex"//性别
#define USERAGE @"userAge"//年龄
#define USERPROTECT @"userProtect"//账号保护
#define USEREMAIL @"userEmail"//邮箱
#define USERDEVICES @"userDevices"//登录设备
#define USERSYSTEM @"userSystem"//手机系统
#define USERIP @"userIP"//手机登录的IP地址
#define USERREALNAME @"userRealName"//真实姓名

