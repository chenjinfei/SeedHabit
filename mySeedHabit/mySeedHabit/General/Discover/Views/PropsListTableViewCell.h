//
//  PropsListTableViewCell.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface PropsListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;
@property (strong, nonatomic) IBOutlet UILabel *signature;

@property (nonatomic, strong) Users *users;

@end
