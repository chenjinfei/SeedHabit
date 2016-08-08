//
//  HabitPropsModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitPropsModel : NSObject


@property (nonatomic, assign) NSInteger prop_time;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *idx;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger mind_note_id;


@end
