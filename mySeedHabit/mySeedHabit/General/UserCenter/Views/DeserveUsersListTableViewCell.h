//
//  DeserveUsersListTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJFDeserveUserModel;

@interface DeserveUsersListTableViewCell : UITableViewCell

// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
// 昵称
@property (strong, nonatomic) IBOutlet UILabel *nicknameView;
// 坚持
@property (strong, nonatomic) IBOutlet UILabel *holdTimeView;
// 关注按钮
@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@property (nonatomic, strong) CJFDeserveUserModel *model;

// 计算高度的类方法
+(CGFloat)heightWithModel: (CJFDeserveUserModel *)model;

@end
