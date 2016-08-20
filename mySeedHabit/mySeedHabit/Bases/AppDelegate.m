//
//  AppDelegate.m
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AppDelegate.h"

#import "CJFTabBarViewController.h"

#import "LoginViewController.h"
#import "UserManager.h"
#import "NSString+CJFString.h"
#import <SCLAlertView.h>

#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#import <EMSDK.h>
//#import "EaseUI.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController *mainVc;

@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation AppDelegate

-(SCLAlertView *)alert {
    if (!_alert) {
        _alert = [[SCLAlertView alloc]init];
    }
    return _alert;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    // 主视图控制器
    self.mainVc = [[CJFTabBarViewController alloc]init];
    // 初始化登录控制器
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    
    // 设置根视图
    self.window.rootViewController = loginVc;
    // 显示
    [self.window makeKeyAndVisible];
    
    // 检查是否已经登录
    if ([[UserManager manager] checkLogin]) {
        // 直接登录
        [self login];
    }
    
    // 检查是否已经登录
    //    [self checkLogin];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    
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
    
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:AppKeyEM];
    options.apnsCertName = AppApnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    // 初始化EaseUI
    //    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:AppKeyEM apnsCertName:AppApnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    return YES;
}

/**
 *  登录
 */
-(void)login {
    
    // 获取本地有持久化登录数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = nil;
    NSNumber *account_type = nil;
    if ([defaults valueForKey:USERNAME] && [defaults valueForKey:USERPASSWORD]) {
        account_type = [NSNumber numberWithInt:4];
        parameters = @{
                       @"account": [NSNumber numberWithInteger:[[defaults valueForKey:USERNAME] integerValue]],
                       @"password": [defaults valueForKey:USERPASSWORD],
                       @"account_type": account_type
                       };
    }else {
        account_type = [NSNumber numberWithInt:1];
        parameters = @{
                       @"account": [defaults valueForKey:USERNAME],
                       @"account_type": account_type
                       };
    }
    
    [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
        if (userData) {
            
            NSLog(@"登录成功");
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.mainVc animated:YES completion:nil];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"登录出错啦， 请重新登录：%@", error);
        [self.alert showWaiting:@"唉哟，感觉..." subTitle:@"登录失败了" closeButtonTitle:nil duration:1.0f];
    }];
    
    
}


/**
 *  弹出登录视图
 */
-(void)showLoginVC {
    
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    loginVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:NO completion:nil];
    
}

/**
 *  检查登录
 */
-(void)checkLogin {
    // 未登录
    if (![[UserManager manager] checkLogin]) {
        
        [self showLoginVC];
        
    }else{
        
        // 获取本地有持久化登录数据
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *parameters = nil;
        NSNumber *account_type = nil;
        if ([defaults valueForKey:USERNAME] && [defaults valueForKey:USERPASSWORD]) {
            account_type = [NSNumber numberWithInt:4];
            parameters = @{
                           @"account": [NSNumber numberWithInteger:[[defaults valueForKey:USERNAME] integerValue]],
                           @"password": [defaults valueForKey:USERPASSWORD],
                           @"account_type": account_type
                           };
        }else {
            account_type = [NSNumber numberWithInt:1];
            parameters = @{
                           @"account": [defaults valueForKey:USERNAME],
                           @"account_type": account_type
                           };
        }
        
        [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
            if (userData) {
                
                NSLog(@"登录成功");
                
            }else {
                
                [self showLoginVC];
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [self showLoginVC];
        }];
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

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
