//
//  DiscoverDetailViewController.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/20.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Notes.h"
#import "Habits.h"
#import "Users.h"
#import "Note.h"
#import "Comments.h"
#import "Props.h"

@interface DiscoverDetailViewController : UIViewController

@property (nonatomic, strong) Notes *notes;
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Habits *habits;

@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *imageArr;

@end
