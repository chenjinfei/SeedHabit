//
//  UserInfoUpdateViewController.h
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeedUser;

@interface UserInfoUpdateViewController : UIViewController

/**
 *  操作标识：
 *
 *  修改密码：flag = 0
 *  修改昵称：flag = 01
 *  修改性别：flag = 02
 *  修改生日：flag = 03
 *  修改签名：flag = 11
 */
@property (nonatomic, strong) NSString *flag;

// 当前登录用户
@property (nonatomic, strong) SeedUser *user;

@end
