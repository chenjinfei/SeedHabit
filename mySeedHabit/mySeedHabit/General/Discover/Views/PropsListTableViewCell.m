//
//  PropsListTableViewCell.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "PropsListTableViewCell.h"
#import "UIImageView+CJFUIImageView.h"

@implementation PropsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUsers:(Users *)users {

    if (_users != users) {
        _users = users;
        self.nickname.text = users.nickname;
        self.signature.text = users.signature;
        
        [self.avatar_small lhy_loadImageUrlStr:[NSString stringWithFormat:@"%@", [NSURL URLWithString:users.avatar_small]] placeHolderImageName:nil radius:20];
    }
    
}



@end
