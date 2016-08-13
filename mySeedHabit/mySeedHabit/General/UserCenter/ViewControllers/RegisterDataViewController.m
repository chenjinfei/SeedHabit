//
//  RegisterDataViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "RegisterDataViewController.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import "UIImage+CJFImage.h"
#import "SCLAlertView.h"

#import "UserManager.h"
#import "NSString+CJFString.h"

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

@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation RegisterDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self loadData];
    
}

-(SCLAlertView *)alert {
    if (!_alert) {
        _alert = [[SCLAlertView alloc]init];
    }
    return  _alert;
}

/**
 *  加载数据
 */
-(void)loadData {
    
    if (self.userProfile != nil && self.account == nil) {
        
        // 显示第三方登录用户信息
        [self setThirdUserProfile];
        
    }
    // 显示手机注册用户信息
    else if(self.account != nil && self.userProfile == nil) {
        
        self.avatar.image = [IMAGE(@"portrait_default.jpg") circleImage];
        
    }
    
}

-(void)setThirdUserProfile {
    // 微博用户信息
    if ([self.userProfile isKindOfClass:[WeiboUser class]]) {
        WeiboUser *user = self.userProfile;
        //        [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.avatarHDUrl] placeholderImage:LOADIMAGE(@"placeHolder.png", nil)];
        [self.avatar lhy_loadImageUrlStr:user.avatarHDUrl placeHolderImageName:@"placeHolder.png" radius:self.avatar.frame.size.width / 2 ];
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    // 男
    UIAlertAction *gentAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.genderFlag = 1;
        [self.gender setTitle:@"男" forState:UIControlStateNormal];
        
    }];
    // 女
    UIAlertAction *ladyAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.genderFlag = 0;
        [self.gender setTitle:@"女" forState:UIControlStateNormal];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不知道。。。x_x" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        self.genderFlag = arc4random_uniform(2);
        if (self.genderFlag == 1) {
            [self.gender setTitle:@"男" forState:UIControlStateNormal];
        }else {
            [self.gender setTitle:@"女" forState:UIControlStateNormal];
        }
        
    }];
    [alertController addAction:gentAction];
    [alertController addAction:ladyAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 提交
- (IBAction)submitClick:(UIButton *)sender {
    
    NSDictionary *parameters = @{
                                 @"account": self.account,
                                 @"avatar": self.avatar.image,
                                 @"gender": [NSNumber numberWithInteger:self.genderFlag],
                                 @"nickname": self.nickname.text,
                                 @"password": [[NSString md5WithString:self.password.text] lowercaseString]
                                 };
    [[UserManager manager] registerByParameters:parameters success:^(NSDictionary *responseObject) {
        
        if (responseObject[@"data"] != nil && [responseObject[@"status"] integerValue] == 0) {
            // 上传头像
            NSDictionary *parameters = @{
                                         @"avatar" : self.avatar.image,
                                         @"id": responseObject[@"data"][@"user"][@"id"]
                                         };
            // 上传更新头像
            [[UserManager manager] avatarUpdateWithParameters:parameters];
            
            // 跳回登录控制器
            if ([self respondsToSelector:@selector(presentingViewController)]){
                
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                
            }
            
        }else {
            
            [self.alert showWaiting:[UIApplication sharedApplication].keyWindow.rootViewController title:@"以老司机的经验告诉你：" subTitle:responseObject[@"info"] closeButtonTitle:@"去改改？^_^" duration:2.0f];
            
        }
        
    } failure:^(NSError *error) {
        ULog(@"注册失败");
    }];
    
    
}




@end
