//
//  UserHaBitList_TBCell.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserHaBitList_TBCell.h"

#import "HabitModel.h"
#import "CJFTools.h"

@implementation UserHaBitList_TBCell

-(void)setModel:(HabitModel *)model {
    _model = model;
    
    _habitTitleView.text = model.name;
    
    NSString *create_timeamp = [NSString stringWithFormat:@"%ld", model.joining_time];
    NSString *create_time = [[CJFTools manager] revertTimeamp: create_timeamp withFormat: @"yyyy-MM-dd"];
    
    // 当前时间
    NSString *currentTimeamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]; //转为字符型
    NSString *currentTime = [[CJFTools manager] revertTimeamp: currentTimeamp withFormat: @"yyyy-MM-dd"];
    
    _habitInfoView.text = [NSString stringWithFormat:@"%@ - %@ 共坚持 %ld 天", create_time , currentTime, model.check_in_times];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
