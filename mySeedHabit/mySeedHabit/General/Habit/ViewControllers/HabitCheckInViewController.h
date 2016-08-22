//
//  HabitCheckInViewController.h
//  mySeedHabit
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeedUser;

@interface HabitCheckInViewController : UIViewController

@property (nonatomic,strong)NSString *habit_idStr;
@property (nonatomic,strong)NSString *check_in_times;
@property (nonatomic,strong)NSString *join_days;
@property (nonatomic,strong)NSString *members;

@property (nonatomic,strong)SeedUser *user;

@end
