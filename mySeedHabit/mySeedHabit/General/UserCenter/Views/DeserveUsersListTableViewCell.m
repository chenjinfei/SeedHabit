//
//  DeserveUsersListTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "DeserveUsersListTableViewCell.h"

#import "CJFDeserveUserModel.h"

#import "UIImageView+CJFUIImageView.h"
#import <UIImageView+WebCache.h>
#import "UIColor+CJFColor.h"
#import "CJFTools.h"
#import <Masonry.h>
#import "UserManager.h"
#import "SeedUser.h"

@interface DeserveUsersListTableViewCell ()

// id
@property (nonatomic, strong) NSNumber *uId;

@end

@implementation DeserveUsersListTableViewCell


-(void)setModel:(CJFDeserveUserModel *)model {
    
    _model = model;
    
    // 记录当前用户的id
    self.uId = model.uId;
    
    // 设置头像
    [_avatarView lhy_loadImageUrlStr:model.avatar_small placeHolderImageName:@"placeHolder.png" radius:20];
    
    // 设置昵称
    _nicknameView.text = model.nickname;
    
    // 设置坚持
    _holdTimeView.text = [NSString stringWithFormat:@"坚持#%@#%ld天", model.habit.name, model.habit.check_in_times];
    
    // 设置关注按钮标题
    if (model.relation_with_me) {
        [self selectedFollowBtn];
    }else {
        [self normalFollowBtn];
    }
    // 边框宽度
    [_followBtn.layer setBorderWidth:1];
    // 设置圆角
    [_followBtn.layer setMasksToBounds:YES];
    [_followBtn.layer setCornerRadius:5.0];
    
    // 创建uiview
    CGFloat subWidth = (SCREEN_WIDTH - 40 - 20) / 3;
    UIView *ctnView = [[UIView alloc]init];
    [self.contentView addSubview:ctnView];
    
    // 添加约束
    UIView *superView = self.contentView;
    [ctnView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(60);
        make.right.equalTo(superView.mas_right).with.mas_offset(0);
        make.left.equalTo(superView.mas_left).with.mas_offset(0);
        make.height.mas_equalTo(subWidth);
    }];
    
    
    NSArray *mindArr = model.habit.mind_notes;
    for (int i = 0; i < mindArr.count; i++) {
        CJFDeserveMindNotes *mindModel = mindArr[i];
        if (mindModel.mind_pic_small != nil) { // 有图片
            
            UIImageView *imgView = [[UIImageView alloc]init];
            [ctnView addSubview:imgView];
            
            imgView.clipsToBounds = YES;
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            
            NSURL *url = [NSURL URLWithString:mindModel.mind_pic_small];
            [imgView sd_setImageWithURL:url placeholderImage:IMAGE(@"placeHolder.png")];
            
            [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ctnView.mas_top).with.mas_offset(0);
                make.left.equalTo(ctnView.mas_left).with.mas_offset(20 + i*subWidth + i*10);
                make.width.and.height.mas_offset(subWidth);
            }];
            
        }else { // 无图片
            
            // 创建背景view
            UIView *yellowBgView = [[UIView alloc]init];
            [ctnView addSubview:yellowBgView];
            
            yellowBgView.backgroundColor = RGB(253, 248, 234);
            
            // 添加背景约束
            [yellowBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ctnView.mas_top).with.mas_offset(0);
                make.left.equalTo(ctnView.mas_left).with.mas_offset(20 + i*subWidth + i*10);
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

+(CGFloat)heightWithModel: (CJFDeserveUserModel *)model {
    return (SCREEN_WIDTH - 40 - 20) / 3 + 60 + 20;
}

// 监听按钮的响应
- (IBAction)followAction:(UIButton *)sender {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    SeedUser *currentUser = [UserManager manager].currentUser;
    NSDictionary *parameters = @{
                                 @"followed_user_id" : self.uId,
                                 @"user_id" : currentUser.uId
                                 };
    NSString *post = nil;
    NSInteger flag = 0;
    post =  sender.selected ? APICancelFollow : APIFollowUser;
    flag = sender.selected ? 0 : 1;
    
    [session POST:post parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@", responseObject);
        if (responseObject[@"data"] != nil && [responseObject[@"status"] integerValue] == 0) {
            NSLog(@"%d", sender.selected);
            if (!flag) {
                [self normalFollowBtn];
            }else {
                [self selectedFollowBtn];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

// 设置关注按钮选中状态
-(void)selectedFollowBtn {
    [_followBtn setSelected:YES];
    //设置边框颜色
    [_followBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
    [_followBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
}

// 设置关注按钮普通状态
-(void)normalFollowBtn {
    [_followBtn setSelected:NO];
    //设置边框颜色
    [_followBtn.layer setBorderColor:[UIColor colorWithHexString:UIMainColor alpha:1].CGColor];
    [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_followBtn setTitleColor:[UIColor colorWithHexString:UIMainColor alpha:1] forState:UIControlStateNormal];
}

/**
 *  获取视图的父视图
 *
 *  @param view 视图控件
 *
 *  @return 父视图图
 */
-(UIView *)getSuperViewWith: (UIView *)view {
    return  view.superview;
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
