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
#import "UserManager.h"

#import <UMSocial.h>


@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 帐号：18716304714
    // 密码：abc1234567890
    
}

// 登录
- (IBAction)loginClick:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"account": [NSNumber numberWithInteger:[self.phoneNumber.text integerValue]],
                                 @"password": self.password.text,
                                 @"account_type": @1
                                 };
    [[UserManager manager] loginWithInfo:parameters success:^(NSDictionary *userData) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"登录成功");
        }];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

// 注册
- (IBAction)registerClick:(UIButton *)sender {
    
    RegisterByPhoneViewController *registerVc = [[RegisterByPhoneViewController alloc]init];
    [self presentViewController:registerVc animated:YES completion:nil];
    
}


// 邮箱登录
- (IBAction)emailLoginClick:(UIButton *)sender {
}

// QQ帐号登录
- (IBAction)qqLoginClick:(UIButton *)sender {
    
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
    
    
}

// 微信帐号登录
- (IBAction)weixinLoginClick:(UIButton *)sender {
    // TODO: 微信登录
}

// 微博帐号登录
- (IBAction)sinaLoginClick:(UIButton *)sender {
    
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [dict valueForKey:snsPlatform.platformName];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            RegisterDataViewController *registerDataVc = [[RegisterDataViewController alloc]init];
            registerDataVc.userProfile = response.thirdPlatformUserProfile;
            [self presentViewController:registerDataVc animated:YES completion:^{
                
            }];
            
            
            
        }});
    
    
    
    
}


@end
