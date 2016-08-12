//
//  UserInfo_TBHeaderView.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo_TBHeaderView : UIView

// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
// 性别图片
@property (strong, nonatomic) IBOutlet UIImageView *genderImgView;
// 习惯数
@property (strong, nonatomic) IBOutlet UILabel *habitCountView;
// 关注数
@property (strong, nonatomic) IBOutlet UILabel *followCountView;
// 粉丝数
@property (strong, nonatomic) IBOutlet UILabel *followerCountView;
// 签名
@property (strong, nonatomic) IBOutlet UILabel *signatureView;

// 列表方式A
@property (strong, nonatomic) IBOutlet UIButton *aListBtn;
// 列表方式B
@property (strong, nonatomic) IBOutlet UIButton *bListBtn;


@end
