//
//  HabitTableViewCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation HabitTableViewCell

#pragma mark 重写set方法给控件赋值
- (void)setHabit:(HabitsModel *)habit
{
    if (_habit != habit) {
        _habit = habit;
        NSURL *url = [NSURL URLWithString:habit.logo_url];
        [self.imageV sd_setImageWithURL:url];
        self.titleL.text = habit.name;
        NSString *string = [NSString stringWithFormat:@"已坚持%ld天",(long)habit.check_in_times];
        self.descL.text = string;
        if (habit.check_in_time == nil) {
            self.timeL.text = nil;
        }else{
            // 将时间戳转换为时间
            NSString *str = habit.check_in_time;
            NSTimeInterval time = [str doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",date);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yy/MM/dd HH:mm:ss"];
            NSString *currentDateStr = [formatter stringFromDate:date];
            self.timeL.text = currentDateStr;
        }
    }
}

@end
