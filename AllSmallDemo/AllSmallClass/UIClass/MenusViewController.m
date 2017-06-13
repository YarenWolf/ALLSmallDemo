//
//  MenusViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/13.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "MenusViewController.h"
#import "IGLDropDownMenu.h"
@interface IGLDemoCustomView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@end
@interface IGLDemoCustomView ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation IGLDemoCustomView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }return self;
}
- (void)commonInit{
    [self initView];
}
- (void)initView{
    self.layer.borderColor = [UIColor colorWithRed:0.18 green:0.59 blue:0.69 alpha:1.0].CGColor;
    self.layer.borderWidth = 2.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.8;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    self.imageView = imageView;
}
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.imageView.frame = self.bounds;
    self.layer.cornerRadius = frame.size.height / 2.0;
}
@end
@interface MenusViewController () <IGLDropDownMenuDelegate>
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, assign) IGLDropDownMenuDirection direction;
@property (nonatomic, strong) IGLDropDownMenu *defaultDropDownMenu;
@property (nonatomic, strong) IGLDropDownMenu *customeViewDropDownMenu;
@end
@implementation MenusViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
        self.direction = IGLDropDownMenuDirectionDown;
    }return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"D1",@"D2",@"D3",@"D4",@"D5",@"D6",@"D7",@"D8",@"D9"]];
    [segmentedControl setFrame:CGRectMake(10, TopHeight, 300, 30)];
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSelectedSegmentIndex:0];
    [self.view addSubview:segmentedControl];
    self.segmentControl = segmentedControl;
    UISegmentedControl *segmentedControl2 = [[UISegmentedControl alloc] initWithItems:@[@"Default",@"CustomView",]];
    [segmentedControl2 setFrame:CGRectMake(10, YH(segmentedControl)+10, 165, 30)];
    [segmentedControl2 addTarget:self action:@selector(segment2Changed:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl2 setSelectedSegmentIndex:0];
    [self.view addSubview:segmentedControl2];
    UISegmentedControl *segmentedControl3 = [[UISegmentedControl alloc] initWithItems:@[@"Down",@"Up",]];
    [segmentedControl3 setFrame:CGRectMake(185, Y(segmentedControl2), 125, 30)];
    [segmentedControl3 addTarget:self action:@selector(segment3Changed:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl3 setSelectedSegmentIndex:0];
    [self.view addSubview:segmentedControl3];
    self.dataArray = @[@{@"image":[UIImage imageNamed:@"loading_1"],@"title":@"Sun"},
                       @{@"image":[UIImage imageNamed:@"loading_2"],@"title":@"Clouds"},
                       @{@"image":[UIImage imageNamed:@"loading_3"],@"title":@"Snow"},
                       @{@"image":[UIImage imageNamed:@"loading_4"],@"title":@"Rain"},
                       @{@"image":[UIImage imageNamed:@"loading_5"],@"title":@"Windy"}];
    [self initDefaultMenu];
    [self initCustomViewMenu];
    self.customeViewDropDownMenu.hidden = YES;
    self.dropDownMenu = self.defaultDropDownMenu;
    [self setUpParamsForDemo1];
    [self.dropDownMenu reloadView];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPW/3, YH(segmentedControl2)+10, 320, 50)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
    self.textLabel.text = @"No Selected.";
}
- (void)initDefaultMenu{
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setIconImage:dict[@"image"]];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    self.defaultDropDownMenu = [[IGLDropDownMenu alloc] init];
    self.defaultDropDownMenu.menuText = @"Choose Weather";
    self.defaultDropDownMenu.dropDownItems = dropdownItems;
    self.defaultDropDownMenu.paddingLeft = 15;
    [self.defaultDropDownMenu setFrame:CGRectMake(60, 150, 200, 45)];
    self.defaultDropDownMenu.delegate = self;
    [self.view addSubview:self.defaultDropDownMenu];
    [self.defaultDropDownMenu reloadView];
}
- (void)initCustomViewMenu{
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        IGLDemoCustomView *customView = [[IGLDemoCustomView alloc] init];
        customView.image = dict[@"image"];
        customView.title = dict[@"title"];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] initWithCustomView:customView];
        [dropdownItems addObject:item];
    }
    IGLDemoCustomView *customView = [[IGLDemoCustomView alloc] init];
    self.customeViewDropDownMenu = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:customView];
    self.customeViewDropDownMenu.dropDownItems = dropdownItems;
    [self.customeViewDropDownMenu setFrame:CGRectMake(135, 150, 50, 50)];
    self.customeViewDropDownMenu.delegate = self;
    [self.view addSubview:self.customeViewDropDownMenu];
    [self.customeViewDropDownMenu reloadView];
    __weak typeof(self) weakSelf = self;
    [self.customeViewDropDownMenu addSelectedItemChangeBlock:^(NSInteger selectedIndex) {
        __strong typeof(self) strongSelf = weakSelf;
        IGLDropDownItem *item = strongSelf.dropDownMenu.dropDownItems[selectedIndex];
        IGLDemoCustomView *selectedView = (IGLDemoCustomView*)item.customView;
        IGLDropDownItem *menuButton = strongSelf.dropDownMenu.menuButton;
        IGLDemoCustomView *buttonView = (IGLDemoCustomView*)menuButton.customView;
        buttonView.image = selectedView.image;
        strongSelf.textLabel.text = [NSString stringWithFormat:@"Selected: %@", selectedView.title];
    }];
}
- (void)segmentChanged:(UISegmentedControl*)segment{
    NSInteger index = segment.selectedSegmentIndex;
    [self setUpParameWithSegmentControlIndex:index];
    [self.dropDownMenu reloadView];
    self.textLabel.text = @"No Selected.";
}
- (void)setUpParameWithSegmentControlIndex:(NSInteger)index{
    [self.dropDownMenu resetParams];
    self.dropDownMenu.direction = self.direction;
    CGFloat x = CGRectGetMinX(self.dropDownMenu.frame);
    CGFloat width = CGRectGetWidth(self.dropDownMenu.frame);
    CGFloat height = CGRectGetHeight(self.dropDownMenu.frame);
    CGFloat y;
    if (self.direction == IGLDropDownMenuDirectionUp) {
        y = 520;
    } else {
        y = 150;
    }
    self.dropDownMenu.frame = CGRectMake(x, y, width, height);
    switch (index) {
        case 0:
            // Demo 1
            [self setUpParamsForDemo1];
            break;
        case 1:
            // Demo 2
            [self setUpParamsForDemo2];
            break;
        case 2:
            // Demo 3
            [self setUpParamsForDemo3];
            break;
        case 3:
            // Demo 4
            [self setUpParamsForDemo4];
            break;
        case 4:
            // Demo 5
            [self setUpParamsForDemo5];
            break;
        case 5:
            // Demo 6
            [self setUpParamsForDemo6];
            break;
        case 6:
            // Demo 7
            [self setUpParamsForDemo7];
            break;
        case 7:
            // Demo 8
            [self setUpParamsForDemo8];
            break;
        case 8:
            // Demo 9
            [self setUpParamsForDemo9];
            break;
        default:
            break;
    }
}
- (void)segment2Changed:(UISegmentedControl*)segment{
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        self.customeViewDropDownMenu.hidden = YES;
        self.dropDownMenu = self.defaultDropDownMenu;
    } else {
        self.defaultDropDownMenu.hidden = YES;
        self.dropDownMenu = self.customeViewDropDownMenu;
    }
    self.dropDownMenu.hidden = NO;
    [self setUpParameWithSegmentControlIndex:self.segmentControl.selectedSegmentIndex];
    self.textLabel.text = @"No Selected.";
    [self.dropDownMenu reloadView];
}
- (void)segment3Changed:(UISegmentedControl*)segment{
    NSInteger index = segment.selectedSegmentIndex;
    self.direction = index == 1 ? IGLDropDownMenuDirectionUp : IGLDropDownMenuDirectionDown;
    [self setUpParameWithSegmentControlIndex:self.segmentControl.selectedSegmentIndex];
    self.textLabel.text = @"No Selected.";
    [self.dropDownMenu reloadView];
}

- (void)setUpParamsForDemo1{
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 5;
}

- (void)setUpParamsForDemo2{
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.itemAnimationDelay = 0.1;
    self.dropDownMenu.rotate = IGLDropDownMenuRotateRandom;
}
- (void)setUpParamsForDemo3{
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.itemAnimationDelay = 0.04;
    self.dropDownMenu.rotate = IGLDropDownMenuRotateLeft;
}
- (void)setUpParamsForDemo4{
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.flipWhenToggleView = YES;
}
- (void)setUpParamsForDemo5{
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
}
- (void)setUpParamsForDemo6{
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    self.dropDownMenu.itemAnimationDelay = 0.1;
}
- (void)setUpParamsForDemo7{
    self.dropDownMenu.gutterY = 0;
    self.dropDownMenu.type = IGLDropDownMenuTypeFlipVertical;
    self.dropDownMenu.animationDuration = 0.2;
}
- (void)setUpParamsForDemo8{
    self.dropDownMenu.gutterY = 0;
    self.dropDownMenu.type = IGLDropDownMenuTypeFlipFromLeft;
    self.dropDownMenu.animationDuration = 0.4;
    self.dropDownMenu.itemAnimationDelay = 0.1;
}
- (void)setUpParamsForDemo9{
    self.dropDownMenu.gutterY = 0;
    self.dropDownMenu.type = IGLDropDownMenuTypeFlipFromRight;
    self.dropDownMenu.animationDuration = 0.4;
    self.dropDownMenu.itemAnimationDelay = 0.1;
}
#pragma mark - IGLDropDownMenuDelegate
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index{
    if (self.dropDownMenu == self.defaultDropDownMenu) {
        IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
        self.textLabel.text = [NSString stringWithFormat:@"Selected: %@", item.text];
    }
}

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu expandingChanged:(BOOL)isExpending{
    NSLog(@"Expending changed to: %@", isExpending? @"expand" : @"fold");
}
@end
