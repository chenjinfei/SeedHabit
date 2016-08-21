//
//  FollowListTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "FollowListTableViewCell.h"

#import "UIImageView+CJFUIImageView.h"
#import "UIColor+CJFColor.h"
#import "SeedUser.h"
#import "UserManager.h"

#import "CJFFollowModel.h"

@interface FollowListTableViewCell ()

// id
@property (nonatomic, strong) NSNumber *uId;

@end

@implementation FollowListTableViewCell


-(void)setModel:(CJFFollowModel *)model {
    
    _model = model;
    
    // 记录当前用户的id
    self.uId = [NSNumber numberWithInteger:[model.uId integerValue]];
    
    // 头像
    [_avatarView lhy_loadImageUrlStr:model.avatar_small placeHolderImageName:@"placeHolder.png" radius:20];
    
    // 昵称
    _nicknameView.text = model.nickname;
    
    // 签名
    _signatureView.text = model.signature;
    
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


// 监听关注按钮
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
