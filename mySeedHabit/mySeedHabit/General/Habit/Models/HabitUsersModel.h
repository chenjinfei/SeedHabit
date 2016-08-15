//
//  HabitUsersModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitUsersModel : NSObject

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, assign) NSInteger expose_diary;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger user_type;

@property (nonatomic, copy) NSString *account_type;

@property (nonatomic, assign) NSInteger isHx;

@property (nonatomic, copy) NSString *avatar_big;

@property (nonatomic, copy) NSString *device;

@property (nonatomic, copy) NSString *qq_account;

@property (nonatomic, copy) NSString *relation_with_me;

@property (nonatomic, assign) NSInteger register_time;

@property (nonatomic, copy) NSString *fans_count;

@property (nonatomic, assign) NSInteger friends_count;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *avatar_small;

@end
