//
//  LeftViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "LeftViewController.h"
#import "ICSDrawerController.h"
@interface ICSPlainColorViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end

@interface ICSPlainColorViewController ()
@property(nonatomic, strong) UIButton *openDrawerButton;
@end
@implementation ICSPlainColorViewController
#pragma mark - Managing the view
- (void)viewDidLoad{
    [super viewDidLoad];
    UIImage *hamburger = [UIImage imageNamed:@"1"];
    NSParameterAssert(hamburger);
    self.openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openDrawerButton.frame = CGRectMake(10.0f, 20.0f, 44.0f, 44.0f);
    [self.openDrawerButton setImage:hamburger forState:UIControlStateNormal];
    [self.openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openDrawerButton];
}
#pragma mark - Configuring the view’s layout behavior
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}
- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
#pragma mark - Open drawer button
- (void)openDrawer:(id)sender{
    [self.drawer open];
}

@end
@interface ICSColorsViewController : UITableViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

- (id)initWithColors:(NSArray *)colors;

@end

static NSString * const kICSColorsViewControllerCellReuseId = @"kICSColorsViewControllerCellReuseId";
@interface ICSColorsViewController ()
@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, assign) NSInteger previousRow;
@end
@implementation ICSColorsViewController
- (id)initWithColors:(NSArray *)colors{
    NSParameterAssert(colors);
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _colors = colors;
    }
    return self;
}

#pragma mark - Managing the view
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kICSColorsViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - Configuring the view’s layout behavior
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSParameterAssert(self.colors);
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSParameterAssert(self.colors);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICSColorsViewControllerCellReuseId
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Color %ld", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = self.colors[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.previousRow) {
        // Close the drawer without no further actions on the center view controller
        [self.drawer close];
    }else {
        // Reload the current center view controller and update its background color
        typeof(self) __weak weakSelf = self;
        [self.drawer reloadCenterViewControllerUsingBlock:^(){
            NSParameterAssert(weakSelf.colors);
            weakSelf.drawer.centerViewController.view.backgroundColor = weakSelf.colors[indexPath.row];
        }];
    }
    self.previousRow = indexPath.row;
}
#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
}
- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
}

@end

@interface LeftViewController ()
@end

@implementation LeftViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    NSArray *colors = @[[UIColor colorWithRed:237.0f/255.0f green:195.0f/255.0f blue:0.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:237.0f/255.0f green:147.0f/255.0f blue:0.0f/255.0f alpha:1.0f],
                        [UIColor colorWithRed:237.0f/255.0f green:9.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
                        ];
    
    ICSColorsViewController *colorsVC = [[ICSColorsViewController alloc] initWithColors:colors];
    ICSPlainColorViewController *plainColorVC = [[ICSPlainColorViewController alloc] init];
    plainColorVC.view.backgroundColor = colors[0];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:colorsVC centerViewController:plainColorVC];
    window.rootViewController = drawer;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
@end
