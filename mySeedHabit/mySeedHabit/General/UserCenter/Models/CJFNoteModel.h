//
//  CJFNoteModel.h
//  mySeedHabit
//  收藏心情列表模型
//
//  Created by cjf on 8/19/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CJFNoteCtnModel,CJFHabitModel,CJFUserModel;
@interface CJFNoteModel : NSObject


@property (nonatomic, assign) NSInteger add_time;

@property (nonatomic, copy) NSString *collect_user_id;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *unique_id;

@property (nonatomic, copy) NSString *collect_type;

@property (nonatomic, strong) CJFNoteCtnModel *note;


@end
@interface CJFNoteCtnModel : NSObject

@property (nonatomic, copy) NSString *habit_id;

@property (nonatomic, assign) NSInteger uId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger prop_count;

@property (nonatomic, copy) NSString *mind_pic_big;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, strong) CJFUserModel *user;

@property (nonatomic, copy) NSString *mind_pic_crop;

@property (nonatomic, strong) CJFHabitModel *habit;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, copy) NSString *check_in_id;

@property (nonatomic, assign) NSInteger add_time;

@property (nonatomic, copy) NSString *mind_pic_small;

@property (nonatomic, copy) NSString *mind_note;

@end

@interface CJFHabitModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *creating_user_id;

@property (nonatomic, assign) NSInteger uId;

@property (nonatomic, assign) NSInteger members;

@property (nonatomic, assign) NSInteger mind_count;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, assign) NSInteger create_time;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger has_joined;

@property (nonatomic, copy) NSString *name;

@end

@interface CJFUserModel : NSObject

@property (nonatomic, copy) NSString *uId;

@property (nonatomic, assign) NSInteger expose_diary;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger user_type;

@property (nonatomic, copy) NSString *account_type;

@property (nonatomic, assign) NSInteger isHx;

@property (nonatomic, copy) NSString *avatar_big;

@property (nonatomic, copy) NSString *qq_account;

@property (nonatomic, copy) NSString *device;

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

