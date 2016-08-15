//
//  HabitPreviewView.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitPreviewView.h"

#import "MindNotesModel.h"
#import <UIImageView+WebCache.h>

@implementation HabitPreviewView

-(void)setModel:(MindNotesModel *)model {
    _model = model;
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:model.mind_pic_small] placeholderImage:IMAGE(@"placeHolder.png")];
    _titleView.text = [NSString stringWithFormat:@"坚持%d天", (int)arc4random_uniform(10)];
    [_propBtn setTitle:[NSString stringWithFormat:@"%ld", model.prop_count] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%ld", model.comment_count] forState:UIControlStateNormal];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //    CGFloat subWidth = ( SCREEN_WIDTH - 40 - (3-1) * 8 ) / 3;
    //    
    //    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, subWidth, subWidth+40);
    //    _picView.frame = CGRectMake(0, 0, subWidth, subWidth);
    
}

@end
