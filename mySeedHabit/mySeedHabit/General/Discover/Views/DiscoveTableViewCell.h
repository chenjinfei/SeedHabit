//
//  DiscoveTableViewCell.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppTools.h"

#import "Users.h"
#import "Note.h"
#import "Notes.h"
#import "Habits.h"
#import "Comments.h"
#import "Props.h"

@interface DiscoveTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *propBtn;
@property (strong, nonatomic) IBOutlet UILabel *propNumber;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UILabel *commentNumber;
@property (strong, nonatomic) IBOutlet UIButton *seedBtn;
@property (strong, nonatomic) IBOutlet UIButton *omitBtn;
@property (nonatomic, strong) UIButton *propListBtn;
@property (nonatomic, strong) UIButton *propInfoBtn;
@property (nonatomic, strong) UIButton *habitNameBtn;
@property (strong, nonatomic) IBOutlet UIButton *avatarBtn;

// Model
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) Notes *notes;
@property (nonatomic, strong) Notes *newsNotes;
@property (nonatomic, strong) Habits *habits;
@property (nonatomic, strong) Comments *comments;
@property (nonatomic, strong) Props *props;

// xib控件
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UILabel *habit_name;
@property (strong, nonatomic) IBOutlet UILabel *add_time;
@property (strong, nonatomic) IBOutlet UILabel *check_in_time;
@property (strong, nonatomic) IBOutlet UIView *backgroundV;

- (CGFloat)Height;

@property (nonatomic, strong) NSArray *usersArr;
@property (nonatomic, strong) NSArray *newsUserArr;

@property (nonatomic, strong) NSMutableArray *imageArr;

// 内容图片
@property (nonatomic, strong) UIImageView *contentImageV;

@end
