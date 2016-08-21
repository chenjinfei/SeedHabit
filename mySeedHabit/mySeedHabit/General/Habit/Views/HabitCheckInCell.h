//
//  HabitCheckInCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitCheckInModel.h"

@interface HabitCheckInCell : UITableViewCell

// 背景V
@property (strong, nonatomic) IBOutlet UIView *backgroundV;

// 按钮个数
@property (nonatomic,assign)int count;

// 星期
@property (nonatomic,strong)UILabel *dataLabel;

// 签到情况
@property (nonatomic,strong)UIButton *check_in_Btn;

// 按钮数组
@property (nonatomic,strong)NSMutableArray *arr;

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UILabel *titleL;

@property (nonatomic,strong)UILabel *check_in_timeL;

@property (nonatomic,strong)UIImageView *iconV;











@end
