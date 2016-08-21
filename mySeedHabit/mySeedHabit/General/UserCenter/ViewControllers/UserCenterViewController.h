//
//  UserCenterViewController.h
//  mySeedHabit
//
//  Created by cjf on 8/8/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SeedUser;
@interface UserCenterViewController : UIViewController

// 用户
@property (nonatomic, strong) SeedUser *user;

@property (nonatomic, strong) UITableView *tableView;

@end
