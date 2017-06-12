//
//  HomeTabBarController.m
//  薛超APP框架
#import "HomeTabBarController.h"
#import "HomeNavigationController.h"
@interface HomeTabBarController ()
@end
@implementation HomeTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark 添加一个子控制器
-(void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{
        viewController.tabBarItem.title = title;
        viewController.tabBarItem.image = [UIImage imageNamed:imageName];
        viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        HomeNavigationController *nav = [[HomeNavigationController alloc] initWithRootViewController:viewController];
        [self addChildViewController:nav];
}

@end
