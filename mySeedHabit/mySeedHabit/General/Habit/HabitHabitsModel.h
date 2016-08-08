//
//  HabitHabitsModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitHabitsModel : NSObject


@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger creating_user_id;

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, assign) NSInteger members;

@property (nonatomic, assign) NSInteger mind_count;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, assign) NSInteger has_joined;


@end
