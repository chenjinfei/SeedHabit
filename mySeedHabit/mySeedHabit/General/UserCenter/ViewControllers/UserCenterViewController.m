//
//  UserCenterViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/8/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserCenterViewController.h"

#import "UserManager.h"
#import "SeedUser.h"
#import "LoginViewController.h"

@interface UserCenterViewController ()

@property (nonatomic, strong) UILabel *username;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    
    self.username = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 150, 40)];
    [self.view addSubview:self.username];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logBtn.frame = CGRectMake(100, 150, 150, 40);
    [logBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // ==== 测试 可删除 ======
    self.username.text = [UserManager manager].currentUser.nickname;
    // ======================
    
}

// ==== 测试 可删除 ======
// 退出登录
- (void)logoutClick:(UIButton *)sender {
    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
        
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
            NSLog(@"登出成功");
        }];
        
    } failure:^(NSError *error) {
        
        ULog(@"%@", error);
        
    }];
}
// ========================

@end
