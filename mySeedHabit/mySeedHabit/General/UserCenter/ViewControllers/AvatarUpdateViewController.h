//
//  AvatarUpdateViewController.h
//  mySeedHabit
//
//  Created by cjf on 8/10/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarUpdateViewController : UIViewController

// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
// 更换头像按钮
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
// 保存到本地按钮
@property (strong, nonatomic) IBOutlet UIButton *saveToLocaleBtn;

@end
