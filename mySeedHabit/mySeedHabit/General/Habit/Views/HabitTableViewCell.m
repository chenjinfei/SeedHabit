//
//  HabitTableViewCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "CJFTools.h"

@implementation HabitTableViewCell
//

- (void)setHabit:(HabitListModel *)habit
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
            self.timeL.text = [[CJFTools manager] revertTimeamp:habit.check_in_time withFormat:@"yy/MM/dd HH:mm:ss"];
        }
    }
    
}
@end
