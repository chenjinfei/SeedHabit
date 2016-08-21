//
//  UserInfoUpdateViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserInfoUpdateViewController.h"

#import "SeedUser.h"
#import "CheckButton.h"
#import "RadioGroup.h"
#import "NSString+CJFString.h"

#import <SCLAlertView.h>

@interface UserInfoUpdateViewController ()

// 导航右按钮：提交按钮
@property (nonatomic, strong) UIButton *submitBtn;
// 输入数据的视图
@property (nonatomic, strong) id inputView;
// 旧密码输入框
@property (nonatomic, strong) UITextField *oldPassword;
// 参数名
@property (nonatomic, strong) NSString *parameterName;

@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation UserInfoUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self handling];
    
}


-(SCLAlertView *)alert {
    if (!_alert) {
        _alert = [[SCLAlertView alloc]init];
    }
    return _alert;
}


/**
 *  创建视图
 */
-(void)buildView {
    
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
    
    // 创建导航右按钮
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.submitBtn.frame = CGRectMake(0, 0, 50, 32);
    [self.submitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submitBarbtn = [[UIBarButtonItem alloc]initWithCustomView:self.submitBtn];
    self.navigationItem.rightBarButtonItems = @[submitBarbtn];
    
}


/**
 *  事件处理
 */
-(void)handling {
    
    // 修改密码
    if ([self.flag isEqualToString:@"0"]) {
        self.navigationItem.title = @"修改密码";
        self.parameterName = @"password";
        [self buildTextFieldWithText:nil];
    }
    // 修改昵称
    else if ([self.flag isEqualToString:@"01"]) {
        self.navigationItem.title = @"昵称";
        self.parameterName = @"nickname";
        [self buildTextFieldWithText:self.user.nickname];
    }
    // 修改性别
    else if ([self.flag isEqualToString:@"02"]) {
        self.navigationItem.title = @"性别";
        self.parameterName = @"gender";
        [self buildCheckButton:self.user.gender];
    }
    // 修改生日
    else if ([self.flag isEqualToString:@"03"]) {
        self.navigationItem.title = @"生日";
        self.parameterName = @"birthday";
        [self buildDatePicker:[NSString stringWithFormat:@"%ld", self.user.birthday]];
    }
    // 修改签名
    else if ([self.flag isEqualToString:@"11"]) {
        self.navigationItem.title = @"签名";
        self.parameterName = @"signature";
        [self buildTextViewWithText:self.user.signature];
        
    }
    
}


/**
 *  提交数据
 *
 *  @param sender 按钮对象
 */
-(void)submitAction: (UIButton *)sender {
    
    // 接收数据
    NSString *dataStr = [[NSString alloc]init];
    
    Class cl = [self.inputView class];
    if ([cl isSubclassOfClass:[UITextField class]]) {
        
        UITextField *textField = (UITextField *)self.inputView;
        dataStr = textField.text;
        
    }else if ([cl isSubclassOfClass:[UITextView class]]) {
        
        UITextView *textView = (UITextView *)self.inputView;
        dataStr = textView.text;
        
    }else if ([cl isSubclassOfClass:[RadioGroup class]]) {
        
        RadioGroup *gp = (RadioGroup *)self.inputView;
        dataStr = gp.value;
        
    }else if ([cl isSubclassOfClass:[UIDatePicker class]]) {
        
        UIDatePicker *dp = (UIDatePicker *)self.inputView;
        dataStr = [NSString stringWithFormat:@"%lu", (long)[dp.date timeIntervalSince1970]];
        
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = nil;
    NSString *url = APIUserUpdate;
    
    // 修改密码
    if ([self.flag isEqualToString:@"0"]) {
        url = APIChangePwd;
        NSLog(@"%@", [[NSString md5WithString:self.oldPassword.text] lowercaseString]);
        parameters = @{
                       @"new_password" : [[NSString md5WithString:dataStr] lowercaseString],
                       self.parameterName : [[NSString md5WithString:self.oldPassword.text] lowercaseString],
                       @"user_id" : self.user.uId
                       };
    }
    // 修改昵称
    else if ([self.flag isEqualToString:@"01"]) {
        parameters = @{
                       @"id" : self.user.uId,
                       self.parameterName : dataStr,
                       @"signature" : self.user.signature
                       };
    }
    // 修改性别
    else if ([self.flag isEqualToString:@"02"]) {
        parameters = @{
                       self.parameterName : dataStr,
                       @"id" : self.user.uId
                       };
    }
    // 修改生日
    else if ([self.flag isEqualToString:@"03"]) {
        parameters = @{
                       self.parameterName : dataStr,
                       @"id" : self.user.uId
                       };
        
    }
    // 修改签名
    else if ([self.flag isEqualToString:@"11"]) {
        parameters = @{
                       self.parameterName : dataStr,
                       @"id" : self.user.uId,
                       @"nickname" : self.user.nickname
                       };
        
    }
    
    [session POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject[@"data"] != nil && [responseObject[@"status"] integerValue] == 0) {
            [self.inputView resignFirstResponder];
            [self.alert showWaiting:[UIApplication sharedApplication].keyWindow.rootViewController title:@"恭喜宝宝" subTitle:@"信息修改成功了喔！" closeButtonTitle:nil duration:1.0f];
            [self.alert alertIsDismissed:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            NSLog(@"%@", responseObject);
            [self.alert showWaiting:[UIApplication sharedApplication].keyWindow.rootViewController title:@"宝宝不开心" subTitle:responseObject[@"info"] closeButtonTitle:nil duration:1.0f];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}



/**
 *  创建输入框
 *
 *  @param text 字符串
 */
-(void)buildTextFieldWithText: (NSString *)text {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    contentView.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:contentView];
    
    if (text) {
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
        tf.text = text;
        tf.backgroundColor = CLEARCOLOR;
        tf.textColor = [UIColor darkGrayColor];
        [tf becomeFirstResponder];
        [contentView addSubview:tf];
        
        self.inputView = tf;
        
    }
    // 密码修改
    else {
        
        contentView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 80);
        
        UITextField *oldPwd = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
        oldPwd.secureTextEntry = YES;
        oldPwd.text = text;
        oldPwd.placeholder = @"旧密码";
        oldPwd.backgroundColor = CLEARCOLOR;
        oldPwd.textColor = [UIColor darkGrayColor];
        [contentView addSubview:oldPwd];
        self.oldPassword = oldPwd;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 39, SCREEN_WIDTH-40, 1)];
        lineView.backgroundColor = RGBA(245, 245, 245, 1);
        [contentView addSubview:lineView];
        
        UITextField *newPwd = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 40)];
        newPwd.secureTextEntry = YES;
        newPwd.text = text;
        newPwd.placeholder = @"新密码";
        newPwd.backgroundColor = CLEARCOLOR;
        newPwd.textColor = [UIColor darkGrayColor];
        [contentView addSubview:newPwd];
        
        self.inputView = newPwd;
        
    }
    
}


/**
 *  创建输入域
 *
 *  @param text 字符串
 */
-(void)buildTextViewWithText: (NSString *)text {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 120)];
    contentView.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:contentView];
    
    if (text) {
        
        UITextView *tf = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 100)];
        tf.text = text;
        tf.backgroundColor = CLEARCOLOR;
        tf.textColor = [UIColor darkGrayColor];
        [tf becomeFirstResponder];
        [contentView addSubview:tf];
        
        self.inputView = tf;
        
    }
    
}


/**
 *  创建日期选择器
 *
 *  @param text 时间戳
 */
-(void)buildDatePicker: (NSString *)text {
    
    UIDatePicker *dp = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.center.y-120, SCREEN_WIDTH, 120)];
    dp.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:dp];
    
    // 时间戳转换成日期
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:self.user.birthday];
    dp.date = currentTime;
    
    self.inputView = dp;
    
}


/**
 *  创建单项选择按钮
 *
 *  @param flag 标识
 */
-(void)buildCheckButton: (NSInteger)flag {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 80)];
    contentView.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:contentView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 39, SCREEN_WIDTH-40, 1)];
    lineView.backgroundColor = RGBA(245, 245, 245, 1);
    [contentView addSubview:lineView];
    
    RadioGroup *group = [[RadioGroup alloc]init];
    
    CheckButton *gent = [[CheckButton alloc] initWithFrame: CGRectMake(0 , 5 , SCREEN_WIDTH , 30 )];
    gent.label.text = @"男";
    gent.label.textAlignment = NSTextAlignmentRight;
    gent.value =[[ NSNumber alloc ]initWithInt: 1];
    gent.style = CheckButtonStyleRadio ;
    [contentView addSubview: gent];
    [group add:gent];
    
    CheckButton *lady = [[CheckButton alloc] initWithFrame: CGRectMake(0 , 45 , SCREEN_WIDTH , 30 )];
    lady.label.text = @"女";
    lady.label.textAlignment = NSTextAlignmentRight;
    lady.value =[[ NSNumber alloc ]initWithInt: 0];
    lady.style = CheckButtonStyleRadio ;
    [contentView addSubview: lady];
    [group add:lady];
    
    if (flag) {
        [gent setChecked:YES];
        [lady setChecked:NO];
    }else {
        [gent setChecked:NO];
        [lady setChecked:YES];
    }
    
    self.inputView = group;
    
}






@end
