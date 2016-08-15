//
//  HabitCheckInCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitCheckInCell.h"

@implementation HabitCheckInCell

- (void)awakeFromNib {
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundV.layer.cornerRadius = 3;
    self.backgroundV.layer.masksToBounds = YES;
}

//- (void)setCheck:(HabitCheckModel *)check
//{
//    _check = check;
//    if ([check valueForKey:@"is_check_in"] != 0) {
//        // selected disabled highlighted
//    }
//    // 时间戳转换
//    NSString *str = [NSString stringWithFormat:@"%@",[check valueForKey:@"check_in_time"]];
//    NSTimeInterval time = [str doubleValue];
//    NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yy:MM:dd HH:mm"];
//    NSString *check_in_timeStr = [formatter stringFromDate:detail];
//    
//    
////    self.check_in_Btn1.state
//    
//}


@end
