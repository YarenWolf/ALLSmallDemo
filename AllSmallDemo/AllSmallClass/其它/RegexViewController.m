/**
 使用正则表达式的步骤:
 1.创建一个正则表达式对象:定义规则
 2.利用正则表达式对象 来测试 相应的字符串
 Pattern : 样式\规则
 NSString *pattern = @"ab7";
 [] : 找到内部的某一个字符即可
 NSString *pattern = @"[0123456789]";
 NSString *pattern = @"[0-9]";
 NSString *pattern = @"[a-zA-Z0-9]";
 NSString *pattern = @"[0-9][0-9]";
 NSString *pattern = @"\\d\\d\\d";
 NSString *pattern = @"\\d{2,4}";
 ? + *
 ? : 0个或者1个
 + : 至少1个
 * : 0个或者多个*/
#import "RegexViewController.h"
#import "RegexKitLite.h"
@interface NSString (Extension)
- (BOOL)isQQ;
- (BOOL)isPhoneNumber;
- (BOOL)isIPAddress;
@end
@implementation NSString (Extension)
- (BOOL)match:(NSString *)pattern{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return results.count > 0;
}
- (BOOL)isQQ{
    // 1.不能以0开头// 2.全部是数字// 3.5-11位
    return [self match:@"^[1-9]\\d{4,10}$"];
}
- (BOOL)isPhoneNumber{
    // 1.全部是数字// 2.11位// 3.以13\15\18\17开头
    return [self match:@"^1[3578]\\d{9}$"];
}
- (BOOL)isIPAddress{
    // 1-3个数字: 0-255// 1-3个数字.1-3个数字.1-3个数字.1-3个数字
    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}
@end
@interface RegexViewController ()

@end
@implementation RegexViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *str = @"#呵呵呵#[偷笑] http://foo.com/blah_blah #解放军#//http://foo.com/blah_blah @Ring花椰菜:就#范德萨发生的#舍不得打[test] 就惯#急急急#着他吧[挖鼻屎]//@崔西狮:小拳头举起又放下了 说点啥好呢…… //@toto97:@崔西狮 蹦米咋不揍他#哈哈哈# http://foo.com/blah_blah";
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    
    // 遍历所有的匹配结果
    [str enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"%@ %@", *capturedStrings, NSStringFromRange(*capturedRanges));
    }];
    
    
    // 以正则表达式为分隔符
    [str enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSLog(@"%@ %@", *capturedStrings, NSStringFromRange(*capturedRanges));
    }];
    
    
    //regex基本使用
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult *result in results) {
        NSLog(@"%@ %@", NSStringFromRange(result.range), [str substringWithRange:result.range]);
    }
}

//修改视频文件名 创业天使-xxx 120101_超清.mp4 --> 120101-创业天使-xxx.mp4
-(void)changeVideoName{
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *dir = @"/Users/apple/Desktop/videos";
    NSArray *subpaths = [mgr subpathsAtPath:dir];
    for (NSString *subpath in subpaths) {
        if (![subpath hasSuffix:@"mp4"]) continue;
        // 获得全路径
        NSString *fullSubpath = [dir stringByAppendingPathComponent:subpath];
        // 获得文件名
        NSString *filename = [subpath.lastPathComponent stringByDeletingPathExtension];
        // 根据文件名获取对应的前缀和后缀
        NSString *prefix = [filename stringByMatching:@"(\\d{6})_.清" capture:YES];
        NSString *suffix = [filename stringByMatching:@"(.+) \\d{6}_.清" capture:YES];
        NSString *newFilename = [NSString stringWithFormat:@"%@-%@", prefix, suffix];
        // 生成新的全路径
        NSString *newFullSubpath = [fullSubpath stringByReplacingOccurrencesOfString:filename withString:newFilename];
        // 剪切\移动
        [mgr moveItemAtPath:fullSubpath toPath:newFullSubpath error:nil];
    }
}

@end
