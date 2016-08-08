//
//  LoginViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "LoginViewController.h"

#import "RegisterByPhoneViewController.h"
#import "RegisterDataViewController.h"
#import "DrawerViewController.h"

#import "UserManager.h"
#import <UMSocial.h>
#import "NSString+CJFString.h"
#import <SCLAlertView.h>
#import <WeiboUser.h>
#import <MJExtension.h>


@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 帐号：18716304714
    // 密码：abc1234567890
    
}

// 懒加载
-(SCLAlertView *)alert {
    _alert = [[SCLAlertView alloc]init];
    return _alert;
}

// 登录
- (IBAction)loginClick:(UIButton *)sender {
    
    // 判断帐号是否已经注册
    NSNumber *n = [NSNumber numberWithInteger:[self.phoneNumber.text integerValue]];
    [[UserManager manager] isTelExists:@{@"account" : n} responseBlock:^(id responseObject) {
        
        // 已经注册
        if ([responseObject[@"data"][@"is_register"] boolValue]) {
            
            // 验证密码输入是否为空
            if ([NSString isValidateEmpty: self.password.text]) {
                [self.alert showWarning:self title:@"唉哟~" subTitle:@"能不能像我一样成熟点？\n输个密码好不？" closeButtonTitle:@"好的" duration:0.0f];
                return ;
            }
            
            // 执行登录操作
            NSDictionary *parameters = @{
                                         @"account": [NSNumber numberWithInteger:[self.phoneNumber.text integerValue]],
                                         @"password": [[NSString md5WithString:self.password.text] lowercaseString],
                                         @"account_type": @4
                                         };
            
            [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
                
                if ([userData[@"status"] intValue] == 0) { // 用户信息匹配成功
                    
                    // 本地持久化登录
                    NSNumber *numName = [NSNumber numberWithInteger:[[parameters valueForKey:@"account"] integerValue]];
                    NSString *password = [parameters valueForKey:@"password"];
                    NSString *username = [NSString stringWithFormat:@"%@", numName];
                    [[UserManager manager] setUserDefaultsWithUserName:username password:password];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else if ([userData[@"status"] intValue] == 2003) {
                    [self.alert showWarning:self title:@"唉哟~" subTitle:@"宝宝输错密码啦！重来。。。" closeButtonTitle:@"好的" duration:0.0f];
                }
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            
            
        }else {
            // 未注册
            [self.alert showWarning:self title:@"唉哟~" subTitle:@"宝宝的号码还没注册喔！去注册吧！" closeButtonTitle:@"好的" duration:0.0f]; // Warning
        }
        
        
    }];
    
    
}

// 注册
- (IBAction)registerClick:(UIButton *)sender {
    
    RegisterByPhoneViewController *registerVc = [[RegisterByPhoneViewController alloc]init];
    [self presentViewController:registerVc animated:YES completion:nil];
    
}


// 邮箱登录
- (IBAction)emailLoginClick:(UIButton *)sender {
    // 提示
    [self.alert showWarning:self title:@"我X~" subTitle:@"程序猿还在加班呢，咱再等等？" closeButtonTitle:@"好的" duration:0.0f];
}

// QQ帐号登录
- (IBAction)qqLoginClick:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            
            //            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NSDictionary *parameters = @{
                                         @"account": [NSString md5WithString:snsAccount.usid],
                                         @"account_type": @1
                                         };
            
            [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    // 本地持久化登录
                    NSString *username = [NSString md5WithString:snsAccount.usid];
                    [[UserManager manager] setUserDefaultsWithUserName:username password:nil];
                    
                }];
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            
        }});
    
    
}

// 微信帐号登录
- (IBAction)weixinLoginClick:(UIButton *)sender {
    // TODO: 微信登录
    // 提示
    [self.alert showWarning:self title:@"我X！" subTitle:@"微信那孙子接入登录需要收费，\n老子不玩了！" closeButtonTitle:@"不玩了！" duration:0.0f];
}

// 微博帐号登录
- (IBAction)sinaLoginClick:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            //            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NSDictionary *parameters = @{
                                         @"account": [NSString md5WithString:snsAccount.usid],
                                         @"account_type": @1
                                         };
            
            [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    // 本地持久化登录
                    NSString *username = [NSString md5WithString:snsAccount.usid];
                    [[UserManager manager] setUserDefaultsWithUserName:username password:nil];
                    
                }];
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            
        }});
    
}


@end
