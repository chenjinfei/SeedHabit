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
    
    if (model.mind_notes.count > 0) {
        
        CGFloat hpWidth = ( SCREEN_WIDTH - 40 - (3-1) * 8 ) / 3;
        
        _habitDynamicView.backgroundColor = RGBA(255, 255, 255, 1);
        _habitDynamicView.clipsToBounds = YES;
        
        for (int i = 0; i < model.mind_notes.count; i++) {
            
            MindNotesModel *mindNoteModel = model.mind_notes[i];
            if (mindNoteModel.mind_pic_small) {
                
                HabitPreviewView *habitPreview = [[[NSBundle mainBundle] loadNibNamed:@"HabitPreviewView" owner:self options:nil] lastObject];
                habitPreview.frame = CGRectMake(10+i*hpWidth+i*8, 0, hpWidth, hpWidth+40);
                habitPreview.model = mindNoteModel;
                [_habitDynamicView addSubview:habitPreview];
                
            }else {
                
                HabitPreviewViewNoImage *habitPreview = [[[NSBundle mainBundle] loadNibNamed:@"HabitPreviewViewNoImage" owner:self options:nil] lastObject];
                habitPreview.frame = CGRectMake(10+i*hpWidth+i*8, 0, hpWidth, hpWidth+40);
                habitPreview.joinTimeamp = model.joining_time;
                habitPreview.model = mindNoteModel;
                [_habitDynamicView addSubview:habitPreview];
                
            }
            _habitDynamicView.frame = CGRectMake(_habitDynamicView.frame.origin.x, _habitDynamicView.frame.origin.y, _habitDynamicView.frame.size.width, hpWidth);
            
            // 只显示前三个习惯记录
            if (i==2) {
                continue;
            }
        }
        
    }else {
        
        //        _habitDynamicView.hidden = YES;
        _habitDynamicView.backgroundColor = CLEARCOLOR;
    }
    
    
}





@end
