//
//  HabitNotesByTimeCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HabitUsersModel.h"
#import "HabitNotesModel.h"
#import "HabitNoteModel.h"
#import "HabitHabitsModel.h"
#import "HabitPropsModel.h"
#import "HabitCommentsModel.h"

@interface HabitNotesByTimeCell : UITableViewCell

// Model
@property (nonatomic,strong)HabitUsersModel *users;
@property (nonatomic,strong)HabitNoteModel *note;
@property (nonatomic,strong)HabitNotesModel *notes;
@property (nonatomic,strong)HabitCommentsModel *comments;
@property (nonatomic,strong)HabitPropsModel *props;
@property (nonatomic,strong)HabitHabitsModel *habits;


@property (strong, nonatomic) IBOutlet UIView *backgroundV;

@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;

@property (strong, nonatomic) IBOutlet UILabel *nickname;

@property (strong, nonatomic) IBOutlet UILabel *check_name;

@property (strong, nonatomic) IBOutlet UILabel *add_time;

@property (strong, nonatomic) IBOutlet UILabel *check_in_times;

@property (strong, nonatomic) IBOutlet UIImageView *mind_pic_small;

@property (strong, nonatomic) IBOutlet UILabel *mind_note;

@property (strong, nonatomic) IBOutlet UILabel *comment_text_content;

@property (strong, nonatomic) IBOutlet UIButton *propUser1;

@property (strong, nonatomic) IBOutlet UIButton *propUser2;

@property (strong, nonatomic) IBOutlet UIButton *propUser3;

@property (strong, nonatomic) IBOutlet UIButton *propUser4;

@property (strong, nonatomic) IBOutlet UIButton *propUser5;

@property (strong, nonatomic) IBOutlet UIButton *propUser6;

@end
