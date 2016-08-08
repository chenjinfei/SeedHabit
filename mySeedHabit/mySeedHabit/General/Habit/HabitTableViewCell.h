//
//  HabitTableViewCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitsModel.h"

@interface HabitTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *descL;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (nonatomic,strong)HabitsModel *habit;

@end
