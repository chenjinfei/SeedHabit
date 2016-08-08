//
//  HabitNoteModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitNoteModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *habit_id;

@property (nonatomic, copy) NSString *mind_note;

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, copy) NSString *check_in_id;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, assign) NSInteger prop_count;

@property (nonatomic, assign) NSInteger add_time;

@end
