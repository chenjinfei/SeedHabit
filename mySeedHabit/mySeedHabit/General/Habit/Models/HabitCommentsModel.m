//
//  HabitCommentsModel.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitCommentsModel.h"

@implementation HabitCommentsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

#pragma mark  model属性与系统字符相同时，更改方法
- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.idx = (NSInteger)[NSString stringWithFormat:@"%@", value];
    }
}

@end
