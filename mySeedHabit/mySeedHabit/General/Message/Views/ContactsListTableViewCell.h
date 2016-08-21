//
//  ContactsListTableViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeedUser;
@interface ContactsListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameView;

@property (nonatomic, strong) SeedUser *model;

@end
