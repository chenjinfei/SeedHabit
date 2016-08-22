//
//  HabitClassifyCell.m
//  mySeedHabit
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitClassifyCell.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

@implementation HabitClassifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    UIView *rootView = self.contentView;
    self.logoImageV = [UIImageView new];
    [rootView addSubview:self.logoImageV];
    [self.logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootView.mas_left).offset(20);
        make.top.equalTo(rootView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.habit_nameL = [UILabel new];
    [rootView addSubview:self.habit_nameL];
    
    self.habit_nameL.font = [UIFont systemFontOfSize:15];
    self.habit_nameL.textColor = [UIColor darkGrayColor];
    
    // 添加约束
    [self.habit_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageV.mas_right).offset(15);
        make.top.equalTo(rootView.mas_top).offset(15);
        make.right.equalTo(rootView.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
    
    self.membersL = [UILabel new];
    [rootView addSubview:self.membersL];
    
    self.membersL.font = [UIFont systemFontOfSize:14];
    self.membersL.textColor = [UIColor lightGrayColor];
    
    // 添加约束
    [self.membersL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.habit_nameL.mas_bottom).offset(5);
        make.left.equalTo(self.logoImageV.mas_right).offset(15);
        make.right.equalTo(rootView.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
    
    self.lineView = [UIView new];
    [rootView addSubview:self.lineView];
    
    self.lineView.backgroundColor = RGB(245, 245, 245);
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.membersL.mas_bottom).offset(10);
        make.left.equalTo(self.logoImageV.mas_right).offset(10);
        make.right.equalTo(rootView.mas_right).offset(-20);
        make.height.equalTo(@1);
    }];
}

- (void)setClassify:(HabitClassifyModel *)classify
{
    if (_classify != classify) {
        _classify = classify;
        NSURL *url = [NSURL URLWithString:classify.logo_url];
        [self.logoImageV sd_setImageWithURL:url];
        self.habit_nameL.text = classify.habit_name;
        NSString *str = [NSString stringWithFormat:@"已有%ld位参与者", classify.members];
        self.membersL.text = str;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
