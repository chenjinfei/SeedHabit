//
//  HabitCheckInCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitCheckInCell.h"
#import "Masonry.h"

@implementation HabitCheckInCell

- (void)awakeFromNib {
    
    // 背景
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundV.layer.cornerRadius = 3;
    self.backgroundV.layer.masksToBounds = YES;
    self.count = 7;
    self.arr = [NSMutableArray array];
    
    // 标题
    self.titleL = [[UILabel alloc]init];
    self.titleL.text = @"生长统计";
    self.titleL.font = [UIFont systemFontOfSize:15 weight:2];
    self.titleL.textColor = [UIColor darkGrayColor];
    
    [self.backgroundV addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundV.mas_top).offset(10);
        make.left.mas_equalTo(self.backgroundV.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    // 坚持天数
    self.check_in_timeL = [[UILabel alloc]init];
    [self.backgroundV addSubview:self.check_in_timeL];
    [self.check_in_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundV.mas_top).offset(15);
        make.right.mas_equalTo(self.backgroundV.mas_right).offset(-35);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2-60, 20));
    }];
    
    // 图标
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"search_32.png"];
    [self.backgroundV addSubview:self.iconV];
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundV.mas_top).offset(15);
        make.right.mas_equalTo(self.backgroundV.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    
    // 白色背景
    self.bgView = [[UIView alloc]init];
    [self.backgroundV addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(5);
        make.left.mas_equalTo(self.backgroundV.mas_left).offset(20);
        make.right.mas_equalTo(self.backgroundV.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.backgroundV.mas_bottom).offset(-10);
    }];
    for (int i = 0; i < self.count; i++) {
        self.dataLabel = [[UILabel alloc]init];
        [self.bgView addSubview:self.dataLabel];
        self.dataLabel.textAlignment = NSTextAlignmentCenter;
        self.dataLabel.textColor = RGB(195, 195, 195);
        self.dataLabel.font = [UIFont systemFontOfSize:14];
        switch (i) {
            case 0:
                self.dataLabel.text = @"日";
                break;
            case 1:
                self.dataLabel.text = @"一";
                break;
            case 2:
                self.dataLabel.text = @"二";
                break;
            case 3:
                self.dataLabel.text = @"三";
                break;
            case 4:
                self.dataLabel.text = @"四";
                break;
            case 5:
                self.dataLabel.text = @"五";
                break;
            case 6:
                self.dataLabel.text = @"六";
                break;
            default:
                break;
        }
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(self.bgView.mas_top).offset(0);
            make.left.mas_equalTo(self.bgView.mas_left).offset(i*(SCREEN_WIDTH-40)/self.count);
        }];
        
        // 签到按钮
        self.check_in_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:self.check_in_Btn];
        self.check_in_Btn.backgroundColor = [UIColor lightGrayColor];
        self.check_in_Btn.layer.cornerRadius = 16;
        self.check_in_Btn.layer.masksToBounds = YES;
        [self.check_in_Btn setBackgroundImage:[UIImage imageNamed:@"check_in2.png"] forState:UIControlStateNormal];
        [self.check_in_Btn setBackgroundImage:[UIImage imageNamed:@"check_in1.png"] forState:UIControlStateSelected];
        
        // 给每个按钮加约束
        [self.check_in_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(self.bgView.mas_top).offset(40);
            make.left.mas_equalTo(self.bgView.mas_left).offset(i*(SCREEN_WIDTH-40)/self.count);
        }];
        
        [self.arr addObject:self.check_in_Btn];
    }
}



@end
