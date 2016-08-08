//
//  Habits.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/3.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Habits : NSObject


@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger creating_user_id;

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, assign) NSInteger members;

@property (nonatomic, assign) NSInteger mind_count;

@property (nonatomic, copy) NSString *logo_chosen_url;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger has_joined;

@property (nonatomic, copy) NSString *name;


@end
