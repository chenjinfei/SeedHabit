//
//  HabitListCell.h
//  myProject
//
//  Created by lanou罗志聪 on 16/8/1.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar_small;
@property (strong, nonatomic) IBOutlet UILabel *nickname;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *add_time;
@property (strong, nonatomic) IBOutlet UILabel *check_in_times;
@property (strong, nonatomic) IBOutlet UIImageView *mind_pic_small;
@property (strong, nonatomic) IBOutlet UILabel *mind_note;


@end
