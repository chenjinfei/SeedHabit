//
//  CJFTabBarViewController.m
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFTabBarViewController.h"

#import "HabitViewController.h"
#import "DiscoverViewController.h"
#import "MessageViewController.h"

#import "UIColor+CJFColor.h"

@interface CJFTabBarViewController ()

@end

@implementation CJFTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *habitNav = [self buildViewControllerWithClassName:@"HabitViewController" title:@"习惯" image:@"habit_32" selectedImage:@"habit_32"];
    UINavigationController *discoverNav = [self buildViewControllerWithClassName:@"DiscoverViewController" title:@"发现" image:@"discover_32" selectedImage:@"discover_32"];
    UINavigationController *messageNav = [self buildViewControllerWithClassName:@"MessageViewController" title:@"信息" image:@"msg3_32" selectedImage:@"msg3_32"];
    
    self.viewControllers = @[habitNav, discoverNav, messageNav];
    
    
}

/**
 *  快速创建导航视图控制器的方法
 *
 *  @param className         视图控制器的类名
 *  @param title             显示在视图控制器的导航标题
 *  @param imageName         视图控制器的标签选项的普通状态图片
 *  @param selectedImageName 视图控制器的标签选项的选中状态图片
 *
 *  @return 导航控制器对象
 */
-(UINavigationController *)buildViewControllerWithClassName:(NSString *)className title: (NSString *)title image:(NSString*)imageName selectedImage: (NSString *)selectedImageName {
    
    UIViewController *newVc = [[NSClassFromString(className) alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newVc];
    
    [nav.navigationBar setTranslucent:NO];
    // 设置导航栏背景颜色
    nav.navigationBar.barTintColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    // 设置导航栏字体颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    newVc.title = title;
    // 设置图片并不受系统的tintcolor所渲染
    newVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:UIMainColor alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:UISelectedColor alpha:1.0],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    return nav;
    
}

@end
