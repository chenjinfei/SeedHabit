//
//  HabitNotesByTimeCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitNotesByTimeCell.h"
#import <UIImageView+WebCache.h>

@implementation HabitNotesByTimeCell

- (void)awakeFromNib {
    self.backgroundV.layer.cornerRadius = 3;
    self.backgroundV.layer.masksToBounds = YES;
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatar_small.layer.cornerRadius = 30;
    self.avatar_small.layer.masksToBounds = YES;
    self.propUser1.layer.cornerRadius = 20;
    self.propUser1.layer.masksToBounds = YES;
    self.propUser2.layer.cornerRadius = 20;
    self.propUser2.layer.masksToBounds = YES;
    self.propUser3.layer.cornerRadius = 20;
    self.propUser3.layer.masksToBounds = YES;
    self.propUser4.layer.cornerRadius = 20;
    self.propUser4.layer.masksToBounds = YES;
    self.propUser5.layer.cornerRadius = 20;
    self.propUser5.layer.masksToBounds = YES;
    self.propUser6.layer.cornerRadius = 20;
    self.propUser6.layer.masksToBounds = YES;
}

- (void)setUsers:(HabitUsersModel *)users
{
    if (_users != users) {
        _users = users;
        self.nickname.text = users.nickname;
        [self.avatar_small sd_setImageWithURL:[NSURL URLWithString:users.avatar_small]];
    }
}

- (void)setNote:(HabitNoteModel *)note
{
    if (_note != note) {
        _note = note;
        [self.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
        self.mind_pic_small.contentMode = UIViewContentModeScaleAspectFill;
        [self.mind_pic_small setClipsToBounds:YES];
        
        // 时间戳转换
        NSString *str = [NSString stringWithFormat:@"%@",[note valueForKey:@"add_time"]];
        NSTimeInterval time = [str doubleValue];
        NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM:dd HH:mm"];
        NSString *add_timeStr = [formatter stringFromDate:detail];
        self.add_time.text = add_timeStr;
        self.mind_note.text = [note valueForKey:@"mind_note"];
    }
}

- (void)setNotes:(HabitNotesModel *)notes
{
    if (_notes != notes) {
        _notes = notes;
        self.check_in_times.text = [NSString stringWithFormat:@"坚持%ld天",(long)notes.check_in_times];
    }
}

- (void)setHabits:(HabitHabitsModel *)habits
{
    if (_habits != habits) {
        _habits = habits;
        NSString *str = [NSString stringWithFormat:@"坚持"];
        self.check_name.text = [str stringByAppendingFormat:@"#%@#",habits.name];
    }
}

- (void)setProps:(HabitPropsModel *)props
{
    if (_props != props) {
        _props = props;
    }
}

- (void)setComments:(HabitCommentsModel *)comments
{
    if (_comments != comments) {
        _comments = comments;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
