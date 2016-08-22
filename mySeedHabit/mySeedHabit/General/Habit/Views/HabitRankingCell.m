//
//  HabitRankingCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitRankingCell.h"
#import "UIImageView+CJFUIImageView.h"

@implementation HabitRankingCell

- (void)setUsers:(HabitUsersModel *)users
{
    _users = users;
    self.nicknameL.text = users.nickname;
    [self.avatar_small lhy_loadImageUrlStr:[users valueForKey:@"avatar_small"] placeHolderImageName:@"placeHolder.png" radius:30 ];
    self.check_in_timesL.text = [NSString stringWithFormat:@"已坚持%@天", [users valueForKey:@"check_in_times"]];
}



@end
