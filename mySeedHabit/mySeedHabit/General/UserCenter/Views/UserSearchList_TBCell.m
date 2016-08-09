//
//  UserSearchList_TBCell.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserSearchList_TBCell.h"

#import "UIImageView+CJFUIImageView.h"
#import <UIImageView+WebCache.h>
#import "SeedUser.h"

@implementation UserSearchList_TBCell


-(void)setModel:(SeedUser *)model {
    
    _model = model;
    
    _nicknameView.text = model.nickname;
    [_avatarView lhy_loadImageUrlStr:model.avatar_small placeHolderImageName:@"placeHolder.png" radius:_avatarView.frame.size.height/2];
    
}


@end
