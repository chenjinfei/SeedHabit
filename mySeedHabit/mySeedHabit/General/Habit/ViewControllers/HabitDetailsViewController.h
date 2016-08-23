//
//  HabitDetailsViewController.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SeedUser;
@class UserManager;

@interface HabitDetailsViewController : UIViewController

// 属性传值 标题
@property (nonatomic,strong)NSString *titleStr;

// 属性传值 习惯id
@property (nonatomic,strong)NSString *habit_idStr;

// 坚持天数
@property (nonatomic,strong)NSString *check_in_times;

// 坚持人数
@property (nonatomic,strong)NSString *members;

// 加入习惯天数
@property (nonatomic,assign)NSString *join_days;

// 当前登录用户
@property (nonatomic, strong)SeedUser *user;

@end
