//
//  HabitListCell.m
//  myProject
//
//  Created by lanou罗志聪 on 16/8/1.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "DiscoverHotCell.h"
#import <UIImageView+WebCache.h>
#import "AppTools.h"

@implementation DiscoverHotCell

- (void)awakeFromNib {
    // Initialization code
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUsers:(Users *)users {

    if (_users != users) {
        _users = users;
        
        self.nickname.text = users.nickname;
        [self.avatar_small sd_setImageWithURL:[NSURL URLWithString:users.avatar_small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
}
- (void)setNote:(Note *)note {

    if (_note != note) {
        _note = note;
        
        [self.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        self.mind_pic_small.contentMode = UIViewContentModeScaleAspectFill;
        [self.mind_pic_small setClipsToBounds:YES];
        
        // 时间戳转换
        // 用户发表时间
        NSString *timeS = [NSString stringWithFormat:@"%@", [note valueForKey:@"add_time"]];
        NSTimeInterval time = [timeS doubleValue];
        NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
        // NSLog(@"date:%@", [detail description]);
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
//        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [date setDateFormat:@"MM-dd HH:mm"];
        NSString *curr = [date stringFromDate:detail];
//         NSLog(@"%@", curr);
        // 当前时间
//        NSDate *nowDate = [NSDate date];
        // 时间间隔
//        double interval = [nowDate timeIntervalSinceDate:detail];
        self.add_time.text = curr;
        
        self.mind_note.text = [note valueForKey:@"mind_note"];
    }
    
}
- (void)setNotes:(Notes *)notes {

    if (_notes != notes) {
        self.check_in_times.text = [NSString stringWithFormat:@"%ld", notes.check_in_times];
        self.check_in_times.text = [self.check_in_times.text stringByAppendingFormat:@"天"];
        _notes = notes;
    }
    
}
- (void)setHabits:(Habits *)habits {

    if (_habits != habits) {
        _habits = habits;
        NSString *str = [NSString stringWithFormat:@"坚持"];
        self.name.text = [str stringByAppendingFormat:@"#%@#", habits.name];
    }
    
}
- (void)setProps:(Props *)props {

    if (_props != props) {
        _props = props;
    }
    
}
- (void)setComments:(Comments *)comments {

    if (_comments != comments) {
        _comments = comments;
    }
    
}

#pragma mark cell 自适应高度
+ (CGFloat)heightWithNoteStr:(NSString *)noteStr commentStr:(NSString *)commentStr{

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIFont *noteFont = [UIFont systemFontOfSize:17];
    CGFloat noteHeight = [AppTools heightWithString:noteStr width:width font:noteFont];
    
    UIFont *commentFont = [UIFont systemFontOfSize:17];
    CGFloat commentHeight = [AppTools heightWithString:commentStr width:width font:commentFont];
    
    return noteHeight + 10 + commentHeight;
}

// 视图改变的时候调用
- (void)layoutSubviews {

    if (self.note != nil) {
        CGFloat width = self.frame.size.width;
        
        // 设置文本详情的frame
        CGFloat noteHeight = 0.0;
        noteHeight = [AppTools heightWithString:[self.note valueForKey:@"mind_note"] width:width font:self.mind_note.font];
        self.mind_note.frame = CGRectMake(0, 450, width, noteHeight);
    }

}

@end
