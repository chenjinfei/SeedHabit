//
//  HabitListCell.h
//  myProject
//
//  Created by lanou罗志聪 on 16/8/1.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Users.h"
#import "Note.h"
#import "Notes.h"
#import "Habits.h"
#import "Comments.h"
#import "Props.h"

@protocol pushDelegate <NSObject>

- (void)propsListPush;
- (void)treeInfoPush;

@end

@interface DiscoverHotCell : UITableViewCell

@property (nonatomic, assign) id<pushDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *propListBtn;
@property (strong, nonatomic) IBOutlet UIButton *treeInfo;

@property (strong, nonatomic) IBOutlet UIView *backgroundV;
// 用户头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;
// 昵称
@property (strong, nonatomic) IBOutlet UILabel *nickname;
// 坚持···
@property (strong, nonatomic) IBOutlet UILabel *name;
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
// Model
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) Notes *notes;
@property (nonatomic, strong) Habits *habits;
@property (nonatomic, strong) Comments *comments;
@property (nonatomic, strong) Props *props;
//返回model对应的cell高度
+ (CGFloat)heightWithNoteStr:(NSString *)noteStr commentStr:(NSString *)commentStr mind_pic_small:(NSString *)mind_pic_small;

@end
