//
//  MsgChatTextReceiveTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/17/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgChatTextReceiveTableViewCell.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <EMSDK.h>

@implementation MsgChatTextReceiveTableViewCell

-(void)setModel:(EMMessage *)model {
    _model = model;
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:model.conversationId type:EMConversationTypeChat createIfNotExist:YES];
    
    [_avatar lhy_loadImageUrlStr:conversation.ext[@"avatar"] placeHolderImageName:@"placeHolder.png" radius:20];
    
    EMTextMessageBody *msgBody = (EMTextMessageBody *)model.body;
    _msgText.text = msgBody.text;
    
}



@end
