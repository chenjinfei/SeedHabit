//
//  MsgChatViewController.h
//  mySeedHabit
//
//  Created by cjf on 8/15/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeedUser;

@interface MsgChatViewController : UIViewController

// 聊天的对象
@property (nonatomic, strong) SeedUser *targetUser;

@end
