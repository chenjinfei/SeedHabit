//
//  FollowListTableViewController.h
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowListTableViewController : UITableViewController

// 控制器title
@property (nonatomic, strong) NSString *vcTitle;

// 请求标识：follow OR fans
@property (nonatomic, strong) NSString *flag;

@end
