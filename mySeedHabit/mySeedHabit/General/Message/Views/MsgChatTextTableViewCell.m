//
//  MsgChatTextTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/17/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgChatTextTableViewCell.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <EMSDK.h>
#import "SeedUser.h"
#import "UserManager.h"

@implementation MsgChatTextTableViewCell

-(void)setModel:(EMMessage *)model {
    _model = model;
    
    SeedUser *user = [UserManager manager].currentUser;
    
    [_avatar lhy_loadImageUrlStr:user.avatar_small placeHolderImageName:@"placeHolder.png" radius:20];
    
    EMTextMessageBody *msgBody = (EMTextMessageBody *)model.body;
    _msgText.text = msgBody.text;
    
}

@end
