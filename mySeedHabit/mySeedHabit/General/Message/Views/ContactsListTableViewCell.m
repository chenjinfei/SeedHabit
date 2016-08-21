//
//  ContactsListTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ContactsListTableViewCell.h"

#import "SeedUser.h"
#import "UIImageView+CJFUIImageView.h"

@implementation ContactsListTableViewCell


-(void)setModel:(SeedUser *)model {
    _model = model;
    
    _nicknameView.text = model.nickname;
    
    [_avatarView lhy_loadImageUrlStr:model.avatar_small placeHolderImageName:@"placeHolder.png" radius:20];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
