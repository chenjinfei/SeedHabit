//
//  HabitNotesModel.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HabitNoteModel;

@interface HabitNotesModel : NSObject

@property (nonatomic, strong) NSArray *props;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, strong) HabitNoteModel *note;

@property (nonatomic, strong) NSArray *comments;

@end
