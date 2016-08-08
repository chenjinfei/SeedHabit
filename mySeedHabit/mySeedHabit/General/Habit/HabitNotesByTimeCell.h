//
//  HabitNotesByTimeCell.h
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HabitUsersModel.h"
#import "HabitNoteModel.h"
#import "HabitNotesModel.h"
#import "HabitHabitsModel.h"
#import "HabitCommentsModel.h"
#import "HabitPropsModel.h"

@interface HabitNotesByTimeCell : UITableViewCell

// Model
@property (nonatomic,strong)HabitUsersModel *users;
@property (nonatomic,strong)HabitNoteModel *note;
@property (nonatomic,strong)HabitNotesModel *notes;
@property (nonatomic,strong)HabitCommentsModel *comments;
@property (nonatomic,strong)HabitPropsModel *props;
@property (nonatomic,strong)HabitHabitsModel *habits;


@property (strong, nonatomic) IBOutlet UIView *backgroundV;

// 用户头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;

// 用户昵称
@property (strong, nonatomic) IBOutlet UILabel *nickname;

// 坚持name
@property (strong, nonatomic) IBOutlet UILabel *check_name;

// 发表时间
@property (strong, nonatomic) IBOutlet UILabel *add_time;

// 坚持天数
@property (strong, nonatomic) IBOutlet UILabel *check_in_times;

// 内容图片
@property (strong, nonatomic) IBOutlet UIImageView *mind_pic_small;

// 内容
@property (strong, nonatomic) IBOutlet UILabel *mind_note;

// 评论
@property (strong, nonatomic) IBOutlet UILabel *comment_text_content;

// 点赞
@property (strong, nonatomic) IBOutlet UIButton *propUser1;
@property (strong, nonatomic) IBOutlet UIButton *propUser2;
@property (strong, nonatomic) IBOutlet UIButton *propUser3;
@property (strong, nonatomic) IBOutlet UIButton *propUser4;
@property (strong, nonatomic) IBOutlet UIButton *propUser5;
@property (strong, nonatomic) IBOutlet UIButton *propUser6;






@end
