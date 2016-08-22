//
//  CJFDeserveUserModel.h
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CJFDeserveHabit,CJFDeserveMindNotes;
@interface CJFDeserveUserModel : NSObject


@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *avatar_small;

@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, copy) NSString *expose_diary;

@property (nonatomic, copy) NSString *account_type;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *fans_count;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger register_time;

@property (nonatomic, assign) NSInteger isHx;

@property (nonatomic, copy) NSString *sina_account;

@property (nonatomic, copy) NSString *friends_count;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *avatar_big;

@property (nonatomic, assign) NSInteger relation_with_me;

@property (nonatomic, strong) NSNumber *uId;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, strong) CJFDeserveHabit *habit;

@property (nonatomic, assign) NSInteger user_type;

@property (nonatomic, copy) NSString *device;


@end
@interface CJFDeserveHabit : NSObject

@property (nonatomic, strong) NSArray<CJFDeserveMindNotes *> *mind_notes;

@property (nonatomic, assign) NSInteger hId;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, copy) NSString *name;

@end

@interface CJFDeserveMindNotes : NSObject

@property (nonatomic, copy) NSString *mind_pic_small;

@property (nonatomic, assign) NSInteger add_time;

@property (nonatomic, copy) NSString *mind_note;

@end

