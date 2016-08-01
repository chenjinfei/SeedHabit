//
//  HabitViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitViewController.h"

#import "UserManager.h"
#import "LoginViewController.h"

@interface HabitViewController ()

@end

@implementation HabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

// 退出登录
- (IBAction)logoutClick:(UIButton *)sender {
    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
            NSLog(@"登出成功");
        }];
    } failure:^(NSError *error) {
        ULog(@"%@", error);
    }];
}

@end
