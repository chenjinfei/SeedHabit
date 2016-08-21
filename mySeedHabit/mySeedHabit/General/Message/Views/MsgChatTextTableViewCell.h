//
//  MsgChatTextTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/17/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMMessage;

@interface MsgChatTextTableViewCell : UITableViewCell

// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
// 文字内容
@property (strong, nonatomic) IBOutlet UILabel *msgText;
// 气泡
@property (strong, nonatomic) IBOutlet UIView *bubble;

@property (nonatomic, strong) EMMessage *model;

@end
