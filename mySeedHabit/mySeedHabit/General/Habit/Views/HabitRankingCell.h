//
//  HabitRankingCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitUsersModel.h"

@interface HabitRankingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *numberL;

@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;

@property (strong, nonatomic) IBOutlet UILabel *nicknameL;

@property (strong, nonatomic) IBOutlet UILabel *check_in_timesL;

@property (strong, nonatomic) IBOutlet UIImageView *cupL;

@property (nonatomic,strong)HabitUsersModel *users;

@end
