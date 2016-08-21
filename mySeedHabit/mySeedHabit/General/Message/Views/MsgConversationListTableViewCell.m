//
//  MsgConversationListTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/17/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgConversationListTableViewCell.h"

#import "CJFTools.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <EMSDK.h>

@implementation MsgConversationListTableViewCell

-(void)setModel:(EMConversation *)model {
    
    _model = model;
    
    // 用户头像
    [_avatar lhy_loadImageUrlStr:model.ext[@"avatar"] placeHolderImageName:@"placeHolder.png" radius:20];
    
    // 用户名
    _username.text = model.ext[@"nickname"];
    
    // 最新的一条消息
    EMTextMessageBody *textBody = (EMTextMessageBody *)model.latestMessage.body;
    if (model.latestMessage.direction == 0) {
        _msgBody.text = [NSString stringWithFormat:@"我: %@", textBody.text];
    }else {
        _msgBody.text = [NSString stringWithFormat:@"%@: %@", model.ext[@"nickname"], textBody.text];
    }
    
    // 未读信息条数
    if (model.unreadMessagesCount > 0) {
        NSString *unReadCount = [NSString stringWithFormat:@"%d", model.unreadMessagesCount];
        [_unReadCount setTitle:unReadCount forState:UIControlStateNormal];
        _unReadCount.backgroundColor = [UIColor orangeColor];
    }else {
        [_unReadCount setTitle:@"" forState:UIControlStateNormal];
        _unReadCount.backgroundColor = CLEARCOLOR;
    }
    
    // 发送时间
    NSString *sendTime = [NSString stringWithFormat:@"%lld", model.latestMessage.timestamp];
    _sendTime.text = [[CJFTools manager] revertTimeamp:sendTime withFormat:@"HH:MM"];
    
}

@end
