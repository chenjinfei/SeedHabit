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

#import <SMS_SDK/SMSSDK.h>

@interface RegisterByPhoneViewController ()

// 电话号码输入框
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
// 发送验证码按钮
@property (strong, nonatomic) IBOutlet UIButton *sendValidateBtn;
// 验证码输入框
@property (strong, nonatomic) IBOutlet UITextField *validateNumber;

@property (nonatomic, strong) SCLAlertView *alert;

//注意＊＊这里不需要✳️号 可以理解为dispatch_time_t 已经包含了
@property (nonatomic, strong)dispatch_source_t time;

@end

@implementation RegisterByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 点击空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
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
    //    [self.alert showWaiting:self title:@"锁理咯" subTitle:@"老王说，你不用验证手机就能注册喔..." closeButtonTitle:nil duration:2.0f];
    
    // 退出键盘
    [self.phoneNumber resignFirstResponder];
    [self.validateNumber resignFirstResponder];
    
    // 手机号码输入验证
    if (![NSString isValidatePhoneNumber:self.phoneNumber.text]) {
        [self.alert showWarning:self title:@"宝宝不开心~" subTitle:@"你输入的不是手机号码。。。" closeButtonTitle:@"换个号码试试..." duration:0.0f];
        return;
    }
    
    [self.view endEditing: YES];
    
    // 关闭按钮的响应事件能力
    [sender setUserInteractionEnabled:NO];
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    __block int count = 60;
    __block typeof(self) wSelf = self;
    dispatch_source_set_event_handler(self.time, ^{
        
        __strong typeof(wSelf) sSelf = wSelf;
        
        //设置当执行60次是取消定时器
        count--;
        if(count == 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 关闭按钮的响应事件能力
                [sSelf.sendValidateBtn setUserInteractionEnabled:YES];
                [sSelf.sendValidateBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
            
            // 移除定时器
            [self removeTimer];
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sSelf.sendValidateBtn setTitle:[NSString stringWithFormat:@"%d S", count] forState:UIControlStateNormal];
            });
            
        }
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumber.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    
    
    
    
    
}


// 移除定时器
-(void)removeTimer {
    
    dispatch_cancel(self.time);
    [self.sendValidateBtn setUserInteractionEnabled:YES];
    [self.sendValidateBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    
}


// 注册
- (IBAction)registerClick:(UIButton *)sender {
    
    // 退出键盘
    [self.phoneNumber resignFirstResponder];
    [self.validateNumber resignFirstResponder];
    
    // 手机号码输入验证
    if (![NSString isValidatePhoneNumber:self.phoneNumber.text]) {
        [self.alert showWarning:self title:@"宝宝不开心~" subTitle:@"你输入的不是手机号码。。。" closeButtonTitle:@"换个号码试试..." duration:0.0f];
        return;
    }
    
    //验证验证码
    [SMSSDK commitVerificationCode:self.validateNumber.text phoneNumber:self.phoneNumber.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"验证成功");
            
            // 移除定时器
            [self removeTimer];
            
            NSInteger phoneInteger = [self.phoneNumber.text integerValue];
            NSNumber *phoneNumber = [NSNumber numberWithInteger:phoneInteger];
            NSDictionary *parameters = @{
                                         @"account": phoneNumber
                                         };
            
            [[UserManager manager] isTelExists:parameters responseBlock:^(id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([responseObject[@"data"][@"is_register"] integerValue]) {
                        [self.alert showWarning:self title:@"小朋友" subTitle:@"你的号码已经注册过了喔。。。" closeButtonTitle:@"咱去登录~好吗？" duration:0.0f];
                    }else  {
                        RegisterDataViewController *registerVc = [[RegisterDataViewController alloc]init];
                        registerVc.account = phoneNumber;
                        [self presentViewController:registerVc animated:YES completion:nil];
                    }
                }
            }];
            
            
            
            
        }
        else
        {
            NSLog(@"错误信息:%@",error);
            [self.alert showWaiting:self title:@"锁理咯" subTitle:@"连隔壁老王都知道，你手机没验证成功..." closeButtonTitle:nil duration:2.0f];
        }
    }];
    
    
    
}

// 退出当前模态控制器
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
