//
//  HabitListModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitListModel : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *logo_chosen_url;

@property (nonatomic, assign) NSInteger banner_id;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, assign) NSInteger mind_count;

@property (nonatomic, copy) NSString *creating_user_id;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, copy) NSString *privates;

@property (nonatomic, copy) NSString *check_in_time;

@property (nonatomic, assign) NSInteger banner_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *banner_url;

@property (nonatomic, assign) NSInteger members;

@property (nonatomic, assign) NSInteger joining_time;

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, copy) NSString *reminder;

@property (nonatomic, copy) NSString *banner_quotation;

@property (nonatomic, copy) NSString *url_title;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, assign) NSInteger join_days;

@property (nonatomic, copy) NSString *des;

@end
