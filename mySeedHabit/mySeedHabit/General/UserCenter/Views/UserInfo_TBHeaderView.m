//
//  UserInfo_TBHeaderView.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserInfo_TBHeaderView.h"

@implementation UserInfo_TBHeaderView

-(void)layoutSubviews {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 150);
}

// 习惯列表
- (IBAction)habitList:(UIButton *)sender {
    NSLog(@"习惯列表");
}

// 关注列表
- (IBAction)followList:(UIButton *)sender {
    NSLog(@"关注列表");
}

// 粉丝列表
- (IBAction)fansList:(UIButton *)sender {
    NSLog(@"粉丝列表");
}

@end
