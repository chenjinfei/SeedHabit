//
//  SeedUser.h
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeedUser : NSObject


@property (nonatomic, strong) NSNumber *uId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *account;

@property (nonatomic, assign) NSInteger isHx;

@property (nonatomic, assign) NSInteger account_type;

@property (nonatomic, strong) NSString *friends_count;

@property (nonatomic, strong) NSString *avatar_big;

@property (nonatomic, strong) NSString *tel_account;

@property (nonatomic, strong) NSString *fans_count;

@property (nonatomic, assign) NSInteger relation_with_me;

@property (nonatomic, assign) NSInteger register_time;

@property (nonatomic, strong) NSString *signature;

@property (nonatomic, assign) NSInteger birthday;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *tel_password;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSString *avatar_small;

@property (nonatomic, strong) NSString *device;

@property (nonatomic, strong) NSString *expose_diary;

@property (nonatomic, strong) NSString *qq_account;



@end
