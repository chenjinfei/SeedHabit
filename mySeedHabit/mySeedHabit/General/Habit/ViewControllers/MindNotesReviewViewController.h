//
//  MindNotesReviewViewController.h
//  习惯：历史回顾
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HabitModel;

@interface MindNotesReviewViewController : UIViewController

// 习惯记录数组
@property (nonatomic, strong) HabitModel *habitModel;

@end