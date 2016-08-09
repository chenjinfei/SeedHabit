//
//  TreeInfo.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeInfo : NSObject


@property (nonatomic, assign) NSInteger isDead;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *tree_address;

@property (nonatomic, assign) NSInteger grow_day;

@property (nonatomic, copy) NSString *last_day_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *note;


@end
