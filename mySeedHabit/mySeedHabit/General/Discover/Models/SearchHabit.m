//
//  SearchHabit.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/17.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "SearchHabit.h"

@implementation SearchHabit

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

#pragma mark  model属性与系统字符相同时，更改方法
-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
//        self.uId = [NSString stringWithFormat:@"%@", value];
        self.uId = value;
    }
    else if ([key isEqualToString:@"description"]) {
        self.desc = [NSString stringWithFormat:@"%@", value];
    }
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"members"]) {
        _members = 0;
    }else {
        [super setNilValueForKey:key];
    }
}


@end
