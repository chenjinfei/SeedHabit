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
#import "HabitPreviewView.h"
#import "HabitPreviewViewNoImage.h"
#import "MindNotesModel.h"
#import <UIImageView+WebCache.h>
#import "CJFDeserveUserModel.h"
#import <Masonry.h>

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
    
    // 动态记录
    CGFloat subWidth = (SCREEN_WIDTH - 30) / 3;
    NSArray *mindArr = model.mind_notes;
    for (int i = 0; i < mindArr.count; i++) {
        CJFDeserveMindNotes *mindModel = mindArr[i];
        if (mindModel.mind_pic_small != nil) { // 有图片
            
            UIImageView *imgView = [[UIImageView alloc]init];
            [_habitDynamicView addSubview:imgView];
            
            imgView.clipsToBounds = YES;
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            
            NSURL *url = [NSURL URLWithString:mindModel.mind_pic_small];
            [imgView sd_setImageWithURL:url placeholderImage:IMAGE(@"placeHolder.png")];
            
            [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_habitDynamicView.mas_top).with.mas_offset(0);
                make.left.equalTo(_habitDynamicView.mas_left).with.mas_offset(i*subWidth + i*5);
                make.width.and.height.mas_offset(subWidth);
            }];
            
        }else { // 无图片
            
            // 创建背景view
            UIView *yellowBgView = [[UIView alloc]init];
            [_habitDynamicView addSubview:yellowBgView];
            
            yellowBgView.backgroundColor = RGB(253, 248, 234);
            
            // 添加背景约束
            [yellowBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_habitDynamicView.mas_top).with.mas_offset(0);
                make.left.equalTo(_habitDynamicView.mas_left).with.mas_offset(i*subWidth + i*5);
                make.width.and.height.mas_offset(subWidth);
            }];
            
            // 创建标题label
            UILabel *mindNote = [[UILabel alloc]init];
            [yellowBgView addSubview:mindNote];
            
            mindNote.text = mindModel.mind_note;
            mindNote.numberOfLines = 0;
            mindNote.textColor = [UIColor brownColor];
            mindNote.font = [UIFont systemFontOfSize: 12];
            
            // 添加标题约束
            [mindNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(yellowBgView.mas_top).with.mas_offset(8);
                make.left.equalTo(yellowBgView.mas_left).with.mas_offset(8);
                make.right.equalTo(yellowBgView.mas_right).with.mas_offset(-8);
                make.height.lessThanOrEqualTo(@(subWidth-20));
            }];
            
            // 创建时间label
            UILabel *timeLabel = [[UILabel alloc]init];
            [yellowBgView addSubview:timeLabel];
            
            NSString *timeF = [[CJFTools manager] revertTimeamp:[NSString stringWithFormat:@"%ld", mindModel.add_time] withFormat:@"yyyy.MM.dd"];
            timeLabel.text = [NSString stringWithFormat:@"-%@-", timeF];
            timeLabel.numberOfLines = 0;
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.textColor = [UIColor brownColor];
            timeLabel.font = [UIFont systemFontOfSize: 10];
            
            // 添加时间label的约束
            [timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(yellowBgView.mas_bottom).with.mas_offset(0);
                make.left.equalTo(yellowBgView.mas_left).with.mas_offset(8);
                make.right.equalTo(yellowBgView.mas_right).with.mas_offset(-8);
                make.height.mas_equalTo(15);
            }];
            
        }
        
    }
    
    
}





@end
