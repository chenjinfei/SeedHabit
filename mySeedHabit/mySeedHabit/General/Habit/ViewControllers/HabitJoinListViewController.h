//
//  HabitJoinListViewController.h
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitJoinListViewController : UIViewController

// 属性传值
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,assign)NSInteger members;
@property (nonatomic,assign)NSString *habit_idStr;
// 从第一页传用户已添加的习惯数组
@property (nonatomic,strong)NSMutableArray *habitArray;

@end
