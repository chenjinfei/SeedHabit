//
//  DiscoveTableViewCell.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "DiscoveTableViewCell.h"
#import "UIImageView+CJFUIImageView.h"
#import <Masonry.h>
#import <UIButton+WebCache.h>

@interface DiscoveTableViewCell ()

@property (strong, nonatomic) IBOutlet UIView *contentV;

// 图片
@property (nonatomic, strong) UIImageView *contentImageV;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) BOOL isImage;
// mind_note
@property (nonatomic, strong) UILabel *mind_note;
@property (nonatomic, assign) CGFloat noteHeight;
// 点赞View
@property (nonatomic, strong) UIView *propV;
@property (nonatomic, assign) BOOL isProp;
@property (nonatomic, assign) CGFloat propHeight;
// 评论
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, assign) CGFloat commentHeight;

@end

@implementation DiscoveTableViewCell

#pragma mark 自定义控件
- (void)awakeFromNib {
    // Initialization code
    
    // 背景View角
    self.backgroundV.layer.cornerRadius = 3;
    self.backgroundV.layer.masksToBounds = YES;
    
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 建立UIIMageView
    self.contentImageV = [[UIImageView alloc] init];
    [self.contentV addSubview:self.contentImageV];
    self.contentImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentImageV setClipsToBounds:YES];
    
    // 建立mind_noteLabel
    self.mind_note = [[UILabel alloc] init];
    [self.contentV addSubview:self.mind_note];
//    self.mind_note.backgroundColor = [UIColor blueColor];
    
    // 建立 PropV
    self.propV = [[UIView alloc] init];
    [self.contentV addSubview:self.propV];
//    self.propV.backgroundColor = [UIColor lightGrayColor];
    
    // 建立 commentV
    self.comment = [[UILabel alloc] init];
    [self.contentV addSubview:self.comment];
//    self.comment.backgroundColor = [UIColor redColor];
    
}

#pragma mark model 赋值
- (void)setNotes:(Notes *)notes {
    
    if (_notes != notes) {
        _notes = notes;
        
        // 坚持的天数
        self.check_in_time.text = [NSString stringWithFormat:@"%ld", notes.check_in_times];
        self.check_in_time.text = [self.check_in_time.text stringByAppendingFormat:@"天"];
        
        // Note
        self.note = notes.note;
        // 内容图片
        [self.contentImageV lhy_loadImageUrlStr:[self.note valueForKey:@"mind_pic_small"] placeHolderImageName:@"placeHolder.png" radius:0];
        if ([self.note valueForKey:@"mind_pic_small"]) {
            self.isImage = YES;
        }
        
        // 时间转换
        // 用户发表时间
        NSString *timeS = [NSString stringWithFormat:@"%@", [self.note valueForKey:@"add_time"]];
        NSTimeInterval time = [timeS doubleValue];
        NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"MM-dd HH:mm"];
        NSString *curr = [date stringFromDate:detail];
        self.add_time.text = curr;
        // 心情
        self.mind_note.text = [self.note valueForKey:@"mind_note"];
        
        
        // 解析评论
        NSArray *commentArr = notes.comments;
        Note *note = notes.note;
        NSLog(@"%@", note);
        NSMutableString *text = [[NSMutableString alloc] init];
        NSMutableArray *comId = [[NSMutableArray alloc] init];
        if (commentArr != nil && commentArr.count > 0) {
            for (Comments *com in commentArr) {
                [comId addObject:[com valueForKey:@"id"]];
//                NSLog(@"%@", [com valueForKey:@"mind_note_id"]);
//                NSLog(@"%@", [note valueForKey:@"id"]);
//                NSLog(@"%@", comId);
//                NSLog(@"%@", [com valueForKey:@"be_commented_id"]);
//                if ([comId containsObject:[com valueForKey:@"be_commented_id"]]) {
//                    NSLog(@"回复");
//                }
                
                if ([com valueForKey:@"mind_note_id"] == [note valueForKey:@"id"]) {
                    NSString *userStr;
                    NSString *comStr;
                    for (Users *users in self.usersArr) {
                        if ([com valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
                            userStr = [NSString stringWithFormat:@"%@", users.nickname];
                            comStr = [NSString stringWithFormat:@"%@", [com valueForKey:@"comment_text_content"]];
                            [text appendFormat:@"%@:%@\n", userStr, comStr];
                        }
                    }
                }
            }
        }
        
        NSLog(@"%@",text);
        self.comment.text = text;
        self.commentNumber.text = [NSString stringWithFormat:@"%ld", commentArr.count];
        // i6Plus （414-60(两边边距)） / 9 = 39.33
        // 每个按键大小固定 32 ,39.33 - 32 = 7.33（每个按键间隔）
        // i6 375  / 8
        // i5、i4 320    / 7
        
        // 判断应该放多少点赞头像
        int count;
        if (SCREEN_WIDTH == 414) {
            count = 9;
        }
        else if (SCREEN_WIDTH == 375) {
            count = 8;
        }
        else {
            count = 7;
        }
        
        // 解析点赞
        NSArray *propsArr = notes.props;
        self.propNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)propsArr.count];
        NSLog(@"%lu", (unsigned long)propsArr.count);
        // 装载点赞头像
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        if (propsArr.count > 0) {
            // 在 关注页面滚着滚着就爆掉了 ？？
//            [__NSCFArray objectAtIndex:]: index (1) beyond bounds (1)' *** First throw call stack:
            // 如果 propsArr.count > 2 ????????
            if (propsArr.count > 2) {
                for (int i = 0; i < count-2; i++) {
                    Props *props = propsArr[i];
                    for (Users *users in self.usersArr) {
                        if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
                            [mArr addObject:users];
                        }
                    }
                }
                
                
                self.isProp = YES;
                for (int i = 0; i < propsArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                    [self.propV addSubview:btn];
//                    btn.backgroundColor = [UIColor yellowColor];
                    btn.layer.cornerRadius = 16;
                    btn.layer.masksToBounds = YES;
                    
                    if (i == 0) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"heart2_32.png"] forState:UIControlStateNormal];
                    }
                    else if (i == count-1) {
                        self.propListBtn = btn;
                        [btn setBackgroundImage:[UIImage imageNamed:@"omit_32.png"] forState:UIControlStateNormal];
                    }
                    else {
//                        NSLog(@"%@",[mArr[i-1] valueForKey:@"avatar_small"]);
                        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[mArr[i-1] valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
                    }
                    // 每个按键的约束
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(32, 32));
                        make.top.mas_equalTo(self.propV.mas_top).offset(15);
                        // 存在小偏差？
                        make.left.mas_equalTo(self.propV.mas_left).offset(20+(float)i*((float)(SCREEN_WIDTH-60)/count));
                    }];
                    //当 个数 达到 ，不再遍历，退出循环
                    if (i == count-1) {
                        break;
                    }
                }

            }
            
        }
        else {
            self.isProp = NO;
        }

#pragma mark 自适应 cell 高度
        if (self.isImage) {
            self.contentImageV.hidden = NO;
            self.imageHeight = SCREEN_WIDTH - 20;
//            NSLog(@"%f", self.imageHeight);
                [self.contentImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.size.mas_equalTo(CGSizeMake(self.imageHeight, self.imageHeight));
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);
                    make.left.mas_equalTo(self.contentV.mas_left).with.offset(0);
                    // 如果心情点赞评论都没有，则图片直接约束 contentV 底部
                    if (self.mind_note.text.length == 0 && self.isProp == 0 && self.comment.text.length == 0) {
                        make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                    }
                }];
            }
        else {
            self.imageHeight = 0;
            self.contentImageV.hidden = YES;
        }
            
        if (self.mind_note.text.length > 0) {
            self.mind_note.hidden = NO;
            self.mind_note.numberOfLines = 0;
            self.noteHeight = [AppTools heightWithString:self.mind_note.text width:SCREEN_WIDTH-60 font:[UIFont boldSystemFontOfSize:17]];
            
            [self.mind_note mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, self.noteHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(20);
                if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(0);
                }
                else
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);

                // 如果点赞评论都没有，则心情直接约束 contentV 底部
                if (self.isProp == 0 && self.comment.text.length == 0) {
                    make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                }
                
            }];
        }
        else {
            self.noteHeight = 0;
            self.mind_note.hidden = YES;
        }
            
        if (self.isProp) {
            self.propV.hidden = NO;
            // 固定高度，PropV 装载 点赞
            self.propHeight = 62.0; // 头像32+上下边距各15
            [self.propV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, self.propHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(0);
                if (self.mind_note.text.length > 0) {
                    make.top.mas_equalTo(self.mind_note.mas_bottom).with.offset(0);
                }
                else if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(0);
                }
                else{
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);
                }
                
                // 如果没有评论，直接约束contentV底部
                if (self.comment.text.length == 0) {
                    make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                }
            }];
        }
        else {
            self.propV.hidden = YES;
            self.propHeight = 0;
        }
        
        if (self.comment.text.length > 0) {
            
            self.comment.hidden = NO;
            self.comment.numberOfLines = 0;
            self.commentHeight = [AppTools heightWithString:self.comment.text width:SCREEN_WIDTH-40 font:[UIFont boldSystemFontOfSize:17]];
            
            [self.comment mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, self.commentHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(20);
                make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                if (self.isProp) {
                    make.top.mas_equalTo(self.propV.mas_bottom).with.offset(0);
                }
                else if (self.mind_note.text.length > 0) {
                    make.top.mas_equalTo(self.mind_note.mas_bottom).with.offset(0);
                }
                else if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(0);
                }
                else
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);
                
            }];
        }
        else{
            self.commentHeight = 0;
            self.comment.hidden = YES;
        }
//        NSLog(@"set: %f, %f, %f, %f", self.imageHeight, self.noteHeight, self.propHeight, self.commentHeight);
    }
    
}


- (CGFloat)Height {
//    NSLog(@"%f, %f, %f, %f", self.imageHeight, self.noteHeight, self.propHeight, self.commentHeight);
    return self.propHeight+self.imageHeight+self.noteHeight+self.commentHeight;
    
}

- (void)setUsers:(Users *)users {
    
    if (_users != users) {
        _users = users;
        self.userId.text = users.nickname;
        [self.imageV lhy_loadImageUrlStr:users.avatar_small placeHolderImageName:@"placeHolder.png" radius:30];
    }
    
}

- (void)setHabits:(Habits *)habits {
    
    if (_habits != habits) {
        _habits = habits;
        NSString *str = [NSString stringWithFormat:@"坚持"];
        self.habit_name.text = [str stringByAppendingFormat:@"#%@#", habits.name];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
