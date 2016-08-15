//
//  HabitClassifyModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitClassifyModel : NSObject

@property (nonatomic, copy) NSString *sequence;

@property (nonatomic, copy) NSString *habit_id;

@property (nonatomic, copy) NSString *habit_name;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, assign) NSInteger members;

@end
