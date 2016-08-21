//
//  MsgConversationListTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/17/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMConversation;

@interface MsgConversationListTableViewCell : UITableViewCell

// 发送时间
@property (strong, nonatomic) IBOutlet UILabel *sendTime;
// 未读信息条数
@property (strong, nonatomic) IBOutlet UIButton *unReadCount;
// 用户名
@property (strong, nonatomic) IBOutlet UILabel *username;
// 消息内容
@property (strong, nonatomic) IBOutlet UILabel *msgBody;
// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar;

@property (nonatomic, strong) EMConversation *model;

@end
