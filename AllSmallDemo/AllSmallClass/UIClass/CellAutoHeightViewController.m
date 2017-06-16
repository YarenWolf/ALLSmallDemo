//
//  CellAutoHeightViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
#import "CellAutoHeightViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
@interface DemoVC5Model : NSObject
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *picName;
@end
@implementation DemoVC5Model
@end
@interface DemoVC5CellTableViewCell : UITableViewCell
@property (nonatomic, strong) DemoVC5Model *model;
@end
@implementation DemoVC5CellTableViewCell{
    UIImageView *_view0;
    UILabel *_view1;
    UILabel *_view2;
    UIImageView *_view3;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }return self;
}
- (void)setup{
    UIImageView *view0 = [UIImageView new];
    view0.backgroundColor = [UIColor redColor];
    _view0 = view0;
    UILabel *view1 = [UILabel new];
    view1.textColor = [UIColor lightGrayColor];
    view1.font = [UIFont systemFontOfSize:16];
    _view1 = view1;
    UILabel *view2 = [UILabel new];
    view2.textColor = [UIColor grayColor];
    view2.font = [UIFont systemFontOfSize:16];
    _view2 = view2;
    UIImageView *view3 = [UIImageView new];
    view3.backgroundColor = [UIColor orangeColor];
    _view3 = view3;
    [self.contentView addSubview:view0];
    [self.contentView addSubview:view1];
    [self.contentView addSubview:view2];
    [self.contentView addSubview:view3];
    _view0.sd_layout
    .widthIs(40)
    .heightIs(40)
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10);
    
    _view1.sd_layout
    .topEqualToView(_view0)
    .leftSpaceToView(_view0, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightRatioToView(_view0, 0.4);
    
    _view2.sd_layout
    .topSpaceToView(_view1, 10)
    .rightSpaceToView(self.contentView, 10)
    .leftEqualToView(_view1)
    .autoHeightRatio(0);
    
    _view3.sd_layout
    .topSpaceToView(_view2, 10)
    .leftEqualToView(_view2)
    .widthRatioToView(_view2, 0.7);
}
- (void)setModel:(DemoVC5Model *)model{
    _model = model;
    _view0.image = [UIImage imageNamed:model.iconName];
    _view1.text = model.name;
    _view2.text = model.content;
    CGFloat bottomMargin = 0;
    // 在实际的开发中，网络图片的宽高应由图片服务器返回然后计算宽高比。
    UIImage *pic = [UIImage imageNamed:model.picName];
    if (pic.size.width > 0) {
        CGFloat scale = pic.size.height / pic.size.width;
        _view3.sd_layout.autoHeightRatio(scale);
        _view3.image = pic;
        bottomMargin = 10;
    } else {
        _view3.sd_layout.autoHeightRatio(0);
    }
    //***********************高度自适应cell设置步骤************************
    [self setupAutoHeightWithBottomView:_view3 bottomMargin:bottomMargin];
}
@end
@interface CellAutoHeightViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation CellAutoHeightViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-TopHeight) style:UITableViewStylePlain];
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    NSArray *iconImageNamesArray = @[@"5.jpg",
                                     @"1.jpg",
                                     @"2.jpg",
                                     @"3.jpg",
                                     @"4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"loading_1",
                                     @"loading_2",
                                     @"loading_3",
                                     @"loading_4",
                                     @"loading_5",
                                     ];
    
    for (int i = 0; i < 10; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        int picRandomIndex = arc4random_uniform(5);
        DemoVC5Model *model = [DemoVC5Model new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.content = textArray[contentRandomIndex];
        // 模拟“有或者无图片”
        int random = arc4random_uniform(100);
        if (random <= 80) {
            model.picName = picImageNamesArray[picRandomIndex];
        }
        [self.modelsArray addObject:model];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤1 * >>>>>>>>>>>>>>>>>>>>>>>>
//    [self.tableView startAutoCellHeightWithCellClass:[DemoVC5CellTableViewCell class] contentViewWidth:APPW];
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [SDCellAutoHeightManager managerWithCellClass:[DemoVC5CellTableViewCell class] tableView:self.tableView];
    }
    self.tableView.cellAutoHeightManager.contentViewWidth = APPW;
    return self.modelsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"test";
    DemoVC5CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoVC5CellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.modelsArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    return [self.tableView.cellAutoHeightManager cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model"];
  
}
@end
