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
#import "NSString+CJFString.h"
#import <SCLAlertView.h>

@interface RegisterByPhoneViewController ()

// 电话号码输入框
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
// 发送验证码按钮
@property (strong, nonatomic) IBOutlet UIButton *sendValidateBtn;
// 验证码输入框
@property (strong, nonatomic) IBOutlet UITextField *validateNumber;

@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation RegisterByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(SCLAlertView *)alert {
    _alert = [[SCLAlertView alloc]init];
    return _alert;
}

/**
 *  发送验证码
 *
 *  @param sender 按钮对象
 */
- (IBAction)sendValidateAction:(UIButton *)sender {
    [self.alert showWaiting:self title:@"锁理咯" subTitle:@"老王说，你不用验证手机就能注册喔..." closeButtonTitle:nil duration:2.0f];
}

// 注册
- (IBAction)registerClick:(UIButton *)sender {
    
    // 退出键盘
    [self.phoneNumber resignFirstResponder];
    
    // 手机号码输入验证
    if (![NSString isValidatePhoneNumber:self.phoneNumber.text]) {
        [self.alert showWarning:self title:@"宝宝不开心~" subTitle:@"你输入的不是手机号码。。。" closeButtonTitle:@"再输..." duration:0.0f];
        return;
    }
    
    NSInteger phoneInteger = [self.phoneNumber.text integerValue];
    NSNumber *phoneNumber = [NSNumber numberWithInteger:phoneInteger];
    NSDictionary *parameters = @{
                                 @"account": phoneNumber
                                 };
    
    [[UserManager manager] isTelExists:parameters responseBlock:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"data"][@"is_register"] integerValue]) {
                [self.alert showWarning:self title:@"玩我呢？" subTitle:@"都注册过了还来？。。。" closeButtonTitle:@"赶紧登录去" duration:0.0f];
            }else  {
                RegisterDataViewController *registerVc = [[RegisterDataViewController alloc]init];
                registerVc.account = phoneNumber;
                [self presentViewController:registerVc animated:YES completion:nil];
            }
        }
    }];
    
}

// 退出当前模态控制器
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
