//
//  AppDelegate.m
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AppDelegate.h"

#import "CJFTabBarViewController.h"
#import "DrawerViewController.h"
#import "LeftViewController.h"

#import "LoginViewController.h"
#import "UserManager.h"

#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@property (nonatomic, strong) DrawerViewController *drawerVc;
@property (nonatomic, strong) UIViewController *mainVc;
@property (nonatomic, strong) LeftViewController *leftVc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 主视图控制器
    self.mainVc = [[CJFTabBarViewController alloc]init];
    // 左视图控制器
    self.leftVc = [[LeftViewController alloc]init];
    // 创建抽屉视图作为根视图控制器
    self.drawerVc = [DrawerViewController drawerWithMainVc:self.mainVc leftVc:self.leftVc leftWidth:SCREEN_WIDTH-80];
    // 设置根视图
    self.window.rootViewController = self.drawerVc;
    // 显示
    [self.window makeKeyAndVisible];
    
    // 检查是否已经登录
    [self checkLogin];
    
    // 设置友盟AppKey
    [UMSocialData setAppKey:AppKeyUmeng];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WeixinAppId appSecret:WeixinAppSecret url:AppShareUrlUmeng];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppKey url:AppShareUrlUmeng];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WeiboAppKey
                                              secret:WeiboAppSecret
                                         RedirectURL:WeiboRedirectUrl];
    
    return YES;
}


-(void)checkLogin {
    if (![[UserManager manager] checkLogin]) {
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        loginVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[DrawerViewController shareDrawer] presentViewController:loginVc animated:NO completion:nil];
    }
}

// 系统回调配置，注意如果同时使用微信支付、支付宝等其他需要改写回调代理的SDK，请在if分支下做区分，否则会影响 分享、登录的回调
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
