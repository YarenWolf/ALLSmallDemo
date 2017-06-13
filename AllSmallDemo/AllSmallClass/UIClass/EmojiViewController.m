
//
//  EmojiViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "EmojiViewController.h"
#import "MLEmojiLabel.h"
@interface EmojiViewController ()<MLEmojiLabelDelegate>
@property (nonatomic, strong) MLEmojiLabel *emojiLabel1;
@property (nonatomic, strong) MLEmojiLabel *emojiLabel2;
@end
@implementation EmojiViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.emojiLabel1];
    CGSize size = [self.emojiLabel1 preferredSizeWithMaxWidth:250];
    self.emojiLabel1.frame = CGRectMake(30, 64, 250, size.height);
    [self.view addSubview:self.emojiLabel2];
    size = [self.emojiLabel2 preferredSizeWithMaxWidth:250];
    self.emojiLabel2.frame = CGRectMake(30, 400, 250, size.height);
}
//这个是通常的用法
- (MLEmojiLabel *)emojiLabel1{
    if (!_emojiLabel1) {
        _emojiLabel1 = [MLEmojiLabel new];
        _emojiLabel1.numberOfLines = 0;
        _emojiLabel1.font = [UIFont systemFontOfSize:15.0f];
        _emojiLabel1.delegate = self;
        _emojiLabel1.textAlignment = NSTextAlignmentLeft;
        _emojiLabel1.backgroundColor = [UIColor clearColor];
        _emojiLabel1.isNeedAtAndPoundSign = YES;
        //        _emojiLabel1.disableThreeCommon = YES;
        //        _emojiLabel1.disableEmoji = YES;
        _emojiLabel1.text = @"/:|-)TableView github:https://github.com/molon/MLEmojiLabel @撒旦 哈哈哈哈#九歌#九黎电话13612341234邮箱13612341234@qq.com旦旦/:dsad旦/::)sss/::~啊是大三的拉了/::B/::|/:8-)/::</::$/::X/::Z/::'(/::-|/::@/::P/::D/::O/::(/::+/:--b/::Q/::T/:,@P/:,@-D/::d/:,@o/::g/:|-)/::!/::L/::>/::,@/:,@f/::-S/:?/:ok/:love/:<L>/:jump/:shake/:<O>/:circle/:kotow/:turn/:skip/:oY链接:http://baidu.com dudl@qq.com";
        //测试TTT原生方法
        [_emojiLabel1 addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:[_emojiLabel1.text rangeOfString:@"TableView"]];
        //这句测试剪切板
        [_emojiLabel1 performSelector:@selector(copy:) withObject:nil afterDelay:0.01f];
    }return _emojiLabel1;
}

//这个是自定义表情正则的用法
- (MLEmojiLabel *)emojiLabel2{
    if (!_emojiLabel2) {
        _emojiLabel2 = [MLEmojiLabel new];
        _emojiLabel2.numberOfLines = 0;
        //        _emojiLabel2.lineBreakMode = NSLineBreakByTruncatingHead;
        _emojiLabel2.font = [UIFont systemFontOfSize:14.0f];
        //下面是自定义表情正则和图像plist的例子
        _emojiLabel2.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel2.customEmojiPlistName = @"expressionImage_custom";
        _emojiLabel2.text = @"微笑[微笑][白眼][白眼][白眼][白眼]微笑[愉快][冷汗][投降]";
    }
    return _emojiLabel2;
}
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type{
    NSLog(@"%@",link);
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSLog(@"点击了某个自添加链接%@",url);
}

@end

