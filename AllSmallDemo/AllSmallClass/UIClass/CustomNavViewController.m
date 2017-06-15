//
//  CustomNavViewController.m
//  AllSmallDemo
//
//  Created by Super on 2017/6/16.
//  Copyright © 2017年 Super. All rights reserved.
//

#import "CustomNavViewController.h"
#import "Navbar.h"
@interface CustomNavViewController ()

@end

@implementation CustomNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationItem setNewTitle:@"测试"];
        [self.navigationItem setBackItemWithTarget:self action:@selector(back:)];
        [self.navigationItem setRightItemWithTarget:self action:@selector(resetStateBar) title:@"重置"];
        
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[Navbar class] toolbarClass:nil];
//    nav.viewControllers = @[viewController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==1) {
        Navbar *bar = (Navbar *)self.navigationController.navigationBar;
        bar.cusBarStyele = UIBarStyleDefault;
        bar.stateBarColor = [UIColor whiteColor];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    Navbar *bar = (Navbar *)self.navigationController.navigationBar;
    bar.cusBarStyele = UIBarStyleBlackOpaque;
    bar.stateBarColor = [UIColor blackColor];
    [super viewWillDisappear:animated];
    
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CustomNavViewController *controller = [[CustomNavViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resetStateBar{
    Navbar *bar = (Navbar *)self.navigationController.navigationBar;
    [bar setDefault];
}
@end

