//
//  HabitPreviewView.h
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MindNotesModel;
@interface HabitPreviewView : UIView

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *picView;
// 标题
@property (strong, nonatomic) IBOutlet UILabel *titleView;
// 喜欢按钮
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
// 评论按钮
@property (strong, nonatomic) IBOutlet UIButton *propBtn;
// 数据模型
@property (nonatomic, strong) MindNotesModel *model;

@end
