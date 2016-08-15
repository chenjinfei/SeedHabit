//
//  PropsListTableViewCell.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "PropsListTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation PropsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avatar_small.layer.cornerRadius = 20;
    self.avatar_small.layer.masksToBounds = YES;
    
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
        
        [self.avatar_small sd_setImageWithURL:[NSURL URLWithString:users.avatar_small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
}
- (IBAction)keepAction:(id)sender {
}

@end
