//
//  NotesCollectionListTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/18/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJFNoteModel;

@interface NotesCollectionListTableViewCell : UITableViewCell

// 白色背景
@property (strong, nonatomic) IBOutlet UIView *whiteBgView;
// 头像
@property (strong, nonatomic) IBOutlet UIButton *avatarView;
// 昵称
@property (strong, nonatomic) IBOutlet UILabel *nicknameView;
// 副标题
@property (strong, nonatomic) IBOutlet UILabel *subTitleView;
// 发布时间
@property (strong, nonatomic) IBOutlet UILabel *pubTimeView;
// 坚持时间
@property (strong, nonatomic) IBOutlet UILabel *holdTimeView;
// 图片
@property (strong, nonatomic) IBOutlet UIImageView *picView;
// 记录内容
@property (strong, nonatomic) UILabel *noteCtnView;

@property (nonatomic, strong) CJFNoteModel *model;

// 计算cell自身的高度
+(CGFloat)heightWithModel: (CJFNoteModel *)model;

@end
