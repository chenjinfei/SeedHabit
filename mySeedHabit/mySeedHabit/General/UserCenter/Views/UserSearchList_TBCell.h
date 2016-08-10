//
//  UserSearchList_TBCell.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeedUser;

@interface UserSearchList_TBCell : UITableViewCell
// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
// 昵称
@property (strong, nonatomic) IBOutlet UILabel *nicknameView;
// 数据模型
@property (nonatomic, strong) SeedUser *model;

@end
