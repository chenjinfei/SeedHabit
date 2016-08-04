//
//  HabitViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitViewController.h"

#import "UserManager.h"
//#import "SeedUser.h"
#import "LoginViewController.h"

@interface HabitViewController ()

@property (strong, nonatomic) IBOutlet UILabel *username;

@end

@implementation HabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mytest:) name:@"UPDATEUSERINFO"object:nil];
    
}

-(void)mytest: (NSNotification *)notification {
    self.username.text = [notification object];
}

-(void)viewWillAppear:(BOOL)animated {
    
    // ==== 测试 可删除 ======
    NSString *name = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    
    if (name) {
        self.username.text = name;
    }
    // ======================
    
}

// ==== 测试 可删除 ======
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
// ========================

@end
