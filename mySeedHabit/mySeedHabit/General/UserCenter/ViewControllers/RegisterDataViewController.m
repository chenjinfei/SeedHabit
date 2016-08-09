//
//  RegisterDataViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "RegisterDataViewController.h"

#import <UIImageView+WebCache.h>

#import "UserManager.h"

#import <WeiboUser.h>

@interface RegisterDataViewController ()
// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
// 头像路径
@property (nonatomic, strong) NSString *avatarUrl;
// 性别
@property (strong, nonatomic) IBOutlet UIButton *gender;
@property (nonatomic, assign) NSInteger genderFlag;
// 昵称
@property (strong, nonatomic) IBOutlet UITextField *nickname;
// 密码
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation RegisterDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 测试数据
    self.genderFlag = 0;
    self.avatarUrl = @"photo.jpg";
    
    // 显示第三方登录用户信息
    [self setThirdUserProfile];
    
}

-(void)setThirdUserProfile {
    // 微博用户信息
    if ([self.userProfile isKindOfClass:[WeiboUser class]]) {
        WeiboUser *user = self.userProfile;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatarHDUrl] placeholderImage:LOADIMAGE(@"placeHolder.png", nil)];
        /// TODO: 图像地址这里应该涉及到图片上传
        self.avatarUrl = @"photo.jpg";
        self.account = [NSNumber numberWithInteger:[user.userID integerValue]];
        self.nickname.text = user.name;
        if ([user.gender isEqualToString:@"m"]) {
            self.genderFlag = 1;
        }else if ([user.gender isEqualToString:@"f"]){
            self.genderFlag = 0;
        }
    }
}

// 性别选择
- (IBAction)genderClick:(UIButton *)sender {
}

// 提交
- (IBAction)submitClick:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"account": self.account,
                                 @"avatar": self.avatarUrl,
                                 @"gender": [NSNumber numberWithInteger:self.genderFlag],
                                 @"nickname": self.nickname.text,
                                 @"password": self.password.text
                                 };
    [[UserManager manager] registerByParameters:parameters success:^(NSDictionary *responseObject) {
        NSLog(@"注册成功");
        /// TODO: 这里应该跳转到根视图控制器
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } failure:^(NSError *error) {
        ULog(@"注册失败");
    }];
    
    
}

@end
