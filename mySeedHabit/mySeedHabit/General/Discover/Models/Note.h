//
//  Note.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/3.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject


@property (nonatomic, copy) NSString *habit_id;

@property (nonatomic, copy) NSString *idx;
//@property (nonatomic, assign) NSInteger idx;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger prop_count;

@property (nonatomic, copy) NSString *mind_pic_big;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, copy) NSString *mind_pic_crop;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *check_in_id;

@property (nonatomic, assign) NSInteger add_time;

@property (nonatomic, copy) NSString *mind_pic_small;

@property (nonatomic, copy) NSString *mind_note;


@end
