//
//  HabitCheckInCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HabitCheckModel.h"

@interface HabitCheckInCell : UITableViewCell

@property (nonatomic,strong)HabitCheckModel *check;

@property (strong, nonatomic) IBOutlet UIView *backgroundV;


@property (strong, nonatomic) IBOutlet UILabel *check_in_timeL;

// 日期
@property (strong, nonatomic) IBOutlet UILabel *date1;

@property (strong, nonatomic) IBOutlet UILabel *date2;

@property (strong, nonatomic) IBOutlet UILabel *date3;

@property (strong, nonatomic) IBOutlet UILabel *date4;

@property (strong, nonatomic) IBOutlet UILabel *date5;

@property (strong, nonatomic) IBOutlet UILabel *date6;

@property (strong, nonatomic) IBOutlet UILabel *date7;

// 签到

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn1;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn2;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn3;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn4;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn5;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn6;

@property (strong, nonatomic) IBOutlet UIButton *check_in_Btn7;



















@end
