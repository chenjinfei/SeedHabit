//
//  HabitPreviewViewNoImage.h
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MindNotesModel;

@interface HabitPreviewViewNoImage : UIView

// 背景view
@property (strong, nonatomic) IBOutlet UIView *bgView;

// 标题
@property (strong, nonatomic) IBOutlet UILabel *mindNoteView;
// 添加时间
@property (strong, nonatomic) IBOutlet UILabel *addTimeView;
// 坚持了x天
@property (strong, nonatomic) IBOutlet UILabel *holdTimeView;
// 点赞按钮
@property (strong, nonatomic) IBOutlet UIButton *propCountBtn;
// 评论按钮
@property (strong, nonatomic) IBOutlet UIButton *commentCountBtn;
// 数据模型
@property (nonatomic, strong) MindNotesModel *model;

// 加入习惯的时间的时间戳
@property (nonatomic, assign) NSInteger joinTimeamp;

@end
