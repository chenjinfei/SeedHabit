//
//  HabitReviewCollectionViewCell.h
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HabitPreviewView;
@class MindNotesModel;

@interface HabitReviewCollectionViewCell : UICollectionViewCell

// 数据模型
@property (nonatomic, strong) MindNotesModel *model;

@end
