//
//  HabitPreviewViewNoImage.m
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitPreviewViewNoImage.h"

#import "MindNotesModel.h"
#import "CJFTools.h"
#import "UILabel+LeftTopAlign.h"

@implementation HabitPreviewViewNoImage

-(void)setModel:(MindNotesModel *)model {
    _model = model;
    
    _mindNoteView.text = model.mind_note;
    
    NSString *addTime = [[CJFTools manager] revertTimeamp:model.add_time withFormat:@"yyyy.MM.dd"];
    _addTimeView.text = [NSString stringWithFormat:@"-%@-", addTime];
    
    NSInteger holdTime = arc4random_uniform(10);
    _holdTimeView.text = [NSString stringWithFormat:@"坚持%ld天", holdTime];
    
    [_propCountBtn setTitle:[NSString stringWithFormat:@"%ld", model.prop_count] forState:UIControlStateNormal];
    [_commentCountBtn setTitle:[NSString stringWithFormat:@"%ld", model.comment_count] forState:UIControlStateNormal];
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    //    CGFloat subWidth = ( SCREEN_WIDTH - 40 - (3-1) * 8 ) / 3;
    //    
    //    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, subWidth, subWidth+40);
    //    _bgView.frame = CGRectMake(0, 0, subWidth, subWidth);
    //    
    //    _mindNoteView.font = [UIFont systemFontOfSize:12];
    [_mindNoteView textLeftTopAlign];
    //    _addTimeView.font = [UIFont systemFontOfSize:10];
    
}

@end
