//
//  MsgBubbleTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/18/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMMessage;
#import "EMConversation.h"

@interface MsgBubbleTableViewCell : UITableViewCell

// 头像
@property (nonatomic, strong) UIImageView *avatarView;
// 昵称
@property (nonatomic, strong) UILabel *nicknameView;
// 气泡
@property (nonatomic, strong) UIView *bubbleView;

// 数据模型
@property (nonatomic, strong) EMMessage *model;

// 会话类型
@property (nonatomic, assign) EMConversationType conversationType;

/**
 *  通过数据模型计算高度
 *
 *  @param message 数据模型
 *
 *  @return 高度
 */
+(CGFloat)heightWithMsgModel: (EMMessage *)message;

@end
