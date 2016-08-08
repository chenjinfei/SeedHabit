//
//  HabitCommentsModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HabitCommentsModel : NSObject

@property (nonatomic, assign) NSInteger comment_time;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger idx;

@property (nonatomic, copy) NSString *mind_note_id;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *be_commented_id;

@property (nonatomic, copy) NSString *comment_text_content;

@end
