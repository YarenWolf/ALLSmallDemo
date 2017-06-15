//
//  RoundOutButtonViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/15.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "RoundOutButtonViewController.h"
#import "LIVBubbleMenu.h"
@interface RoundOutButtonViewController ()<LIVBubbleButtonDelegate>
@property LIVBubbleMenu* bubbleMenu;
@property NSMutableArray *images;
@property (strong, nonatomic) UIButton *moodButton;
@end

@implementation RoundOutButtonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _moodButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 100, 30)];
    [_moodButton setTitle:@"出现按钮" forState:UIControlStateNormal];
    _moodButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:_moodButton];
    [_moodButton addTarget:self action:@selector(moodButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _images = [NSMutableArray arrayWithCapacity:10];
    for(int i=1;i<11;i++){
        [_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i]]];
    }
}

- (void)moodButtonTapped {
    _bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.moodButton.center radius:150 menuItems:_images inView:self.view];
    _bubbleMenu.delegate = self;
    _bubbleMenu.easyButtons = NO;
//    _bubbleMenu.bubbleStartAngle = 0.0f;
//    _bubbleMenu.bubbleTotalAngle = 180.0f;
    [_bubbleMenu show];
}
#pragma mark - Delegates
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index {
    NSLog(@"User has selected bubble index: %tu", index);
}

-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu {
    NSLog(@"LIVBubbleMenu has been hidden");
}

@end

