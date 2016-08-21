//
//  CalendarDateView.h
//  mySeedHabit
//
//  Created by lanou on 16/8/17.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDate.h"

@interface CalendarDateView : UIView

@property (nonatomic,strong)NSDate *date;

@property (nonatomic,copy)void(^calendarBlock)(NSInteger day,NSInteger month,NSInteger year);

@property (nonatomic,strong)UIButton *dayButton;

@property (nonatomic,strong)NSMutableArray *signArray;

- (void)setStyle_Today_Signed:(UIButton *)btn;
- (void)setStyle_Today:(UIButton *)btn;

@end
