//
//  HabitHabitsModel.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitHabitsModel.h"

@implementation HabitHabitsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.idx = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"description"]) {
        self.des = [NSString stringWithFormat:@"%@",value];
    }
}

@end
