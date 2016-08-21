//
//  HabitReviewCollectionViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitReviewCollectionViewCell.h"

#import "HabitPreviewView.h"
#import "HabitPreviewViewNoImage.h"
#import "MindNotesModel.h"

@implementation HabitReviewCollectionViewCell

-(void)setModel:(MindNotesModel *)model {
    
    _model = model;
    
    MindNotesModel *mindNoteModel = model;
    if (mindNoteModel.mind_pic_small && mindNoteModel.mind_pic_small.length != 0) {
        
        HabitPreviewView *habitPreview = [[[NSBundle mainBundle] loadNibNamed:@"HabitPreviewView" owner:self options:nil] lastObject];
        habitPreview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width+40);
        habitPreview.model = mindNoteModel;
        [self.contentView addSubview:habitPreview];
        
    }else {
        
        HabitPreviewViewNoImage *habitPreview = [[[NSBundle mainBundle] loadNibNamed:@"HabitPreviewViewNoImage" owner:self options:nil] lastObject];
        habitPreview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width+40);
        //        habitPreview.joinTimeamp = model.joining_time;
        habitPreview.model = mindNoteModel;
        [self.contentView addSubview:habitPreview];
        
    }
    
    
}


@end
