//
//  DiscoverDetailViewController.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/20.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Notes.h"
#import "Habits.h"
#import "Users.h"
#import "Note.h"
#import "Comments.h"
#import "Props.h"

@interface DiscoverDetailViewController : UIViewController

@property (nonatomic, strong) NSString *habitId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) Notes *notes;
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Habits *habits;

@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *imageArr;

// 获取历史回顾的网址参数
// http://api.idothing.com/zhongzi/v2.php/MindNote/listUserNotes
//detail=1&habit_id=92&next_id=19162565&target_user_id=1418172&user_id=1878988

//@property (nonatomic, strong) NSString *detail;
//@property (nonatomic, strong) NSString *habit_id;
//@property (nonatomic, strong) NSString *next_id;
//@property (nonatomic, strong) NSString *target_user_id;
//@property (nonatomic, strong) NSString *user_id;

// 收藏网址
// http://api.idothing.com/zhongzi/v2.php/Collect/isCollected
// collect_type=1&unique_id=19162566&user_id=1878988

@end
