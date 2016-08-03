//
//  RegisterByPhoneViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "RegisterByPhoneViewController.h"

#import "RegisterDataViewController.h"
#import "UserManager.h"

@interface RegisterByPhoneViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation RegisterByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 注册
- (IBAction)registerClick:(UIButton *)sender {
    
    NSInteger phoneInteger = [self.phoneNumber.text integerValue];
    NSNumber *phoneNumber = [NSNumber numberWithInteger:phoneInteger];
    NSDictionary *parameters = @{
                                 @"account": phoneNumber
                                 };
    
    [[UserManager manager] isTelExists:parameters responseBlock:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"data"][@"is_register"] integerValue]) {
                ULog(@"号码已经被注册");
            }else  {
                RegisterDataViewController *registerVc = [[RegisterDataViewController alloc]init];
                registerVc.account = phoneNumber;
                [self presentViewController:registerVc animated:YES completion:^{
                    
                }];
            }
        }
    }];
    
}

// 退出当前模态控制器
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
