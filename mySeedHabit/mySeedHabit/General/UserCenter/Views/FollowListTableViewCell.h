//
//  FollowListTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJFFollowModel;

@interface FollowListTableViewCell : UITableViewCell

// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
// 昵称
@property (strong, nonatomic) IBOutlet UILabel *nicknameView;
// 签名
@property (strong, nonatomic) IBOutlet UILabel *signatureView;
// 关注按钮
@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@property (nonatomic, strong) CJFFollowModel *model;

@end
