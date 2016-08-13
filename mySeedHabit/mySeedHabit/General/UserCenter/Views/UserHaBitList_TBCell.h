//
//  UserHaBitList_TBCell.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HabitModel;

@interface UserHaBitList_TBCell : UITableViewCell

// 习惯标题
@property (strong, nonatomic) IBOutlet UILabel *habitTitleView;
// 习惯信息：开始时间-结束时间，共坚持n天
@property (strong, nonatomic) IBOutlet UILabel *habitInfoView;
// 习惯动态区域
@property (strong, nonatomic) IBOutlet UIView *habitDynamicView;

// 习惯数据模型
@property (nonatomic, strong) HabitModel *model;

@end
