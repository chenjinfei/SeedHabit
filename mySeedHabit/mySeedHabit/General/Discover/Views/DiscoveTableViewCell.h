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

// 代理方法
@protocol pushDelegate <NSObject>

- (void)hotPropsListPush:(id)sender;
- (void)hotTreeInfoPush:(id)sender;
- (void)hotAlbumPush:(id)sender;
/*
- (void)keepPropsListPush:(id)sender;
- (void)keepTreeInfoPush:(id)sender;
- (void)keepAlbumPush:(id)sender;

- (void)newPropsListPush:(id)sender;
- (void)newTreeInfoPush:(id)sender;
- (void)newAlbumPush:(id)sender;
*/
@end

@interface DiscoveTableViewCell : UITableViewCell

// 代理
@property (nonatomic, assign) id<pushDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *propBtn;
@property (strong, nonatomic) IBOutlet UILabel *propNumber;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UILabel *commentNumber;
@property (strong, nonatomic) IBOutlet UIButton *seedBtn;
@property (strong, nonatomic) IBOutlet UIButton *omitBtn;
@property (nonatomic, strong) UIButton *propListBtn;

// Model
@property (nonatomic, strong) Users *users;
@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) Notes *notes;
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

@end
