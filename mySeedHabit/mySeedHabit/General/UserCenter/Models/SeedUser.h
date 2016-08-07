//
//  SeedUser.h
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeedUser : NSObject


@property (nonatomic, assign) NSNumber *uId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) NSInteger isHx;

@property (nonatomic, assign) NSInteger account_type;

@property (nonatomic, copy) NSString *friends_count;

@property (nonatomic, copy) NSString *avatar_big;

@property (nonatomic, copy) NSString *tel_account;

@property (nonatomic, copy) NSString *fans_count;

@property (nonatomic, assign) NSInteger relation_with_me;

@property (nonatomic, assign) NSInteger register_time;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *tel_password;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *avatar_small;

@property (nonatomic, copy) NSString *device;

@property (nonatomic, copy) NSString *expose_diary;

@property (nonatomic, copy) NSString *qq_account;



@end
