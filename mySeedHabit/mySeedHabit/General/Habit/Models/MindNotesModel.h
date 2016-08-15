//
//  MindMotesModel.h
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MindNotesModel : NSObject


@property (nonatomic, copy) NSString *mind_pic_small;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *habit_id;

@property (nonatomic, copy) NSString *mind_note;

@property (nonatomic, assign) NSInteger mId;

@property (nonatomic, copy) NSString *mind_pic_big;

@property (nonatomic, copy) NSString *check_in_id;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, assign) NSInteger prop_count;

@property (nonatomic, copy) NSString *add_time;


@end
