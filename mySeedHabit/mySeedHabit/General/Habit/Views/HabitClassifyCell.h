//
//  HabitClassifyCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitClassifyModel.h"

@interface HabitClassifyCell : UITableViewCell

@property (nonatomic,strong)UIImageView *logoImageV;
@property (nonatomic,strong)UILabel *habit_nameL;
@property (nonatomic,strong)UILabel *membersL;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)HabitClassifyModel *classify;

@end
