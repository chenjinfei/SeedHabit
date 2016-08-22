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

- (void)setUser:(SeedUser *)user
{
    _user = user;
    self.nicknameL.text = user.nickname;
    [self.avatar_small lhy_loadImageUrlStr:[user valueForKey:@"avatar_small"] placeHolderImageName:@"placeHolder.png" radius:25];
    self.nicknameL.textColor = [UIColor darkGrayColor];
    self.check_in_timesL.text = [NSString stringWithFormat:@"已坚持%@天", [user valueForKey:@"check_in_times"]];
    self.check_in_timesL.textColor = [UIColor lightGrayColor];
}



@end
