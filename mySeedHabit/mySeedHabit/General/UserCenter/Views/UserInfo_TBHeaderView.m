//
//  UserInfo_TBHeaderView.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserInfo_TBHeaderView.h"

#import "FollowListTableViewController.h"
#import "UIView+CJFUIView.h"

@implementation UserInfo_TBHeaderView

-(void)layoutSubviews {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 150);
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

// 习惯列表
- (IBAction)habitList:(UIButton *)sender {
    NSLog(@"习惯列表");
    
    // 递归找到按钮所在的tableView
    UIView *superView = [self getSuperViewWith:sender];
    while (![superView isKindOfClass:[UITableView class]]) {
        superView = [self getSuperViewWith:superView];
    }
    
    UITableView *superTableView = (UITableView *)superView;
    [UIView animateWithDuration:0.25 animations:^{
        superTableView.contentOffset = CGPointMake(0, 150);
    }];
    
}

// 关注列表
- (IBAction)followList:(UIButton *)sender {
    NSLog(@"关注列表");
    
    [self getCurrentViewController].hidesBottomBarWhenPushed = YES;
    FollowListTableViewController *flVc = [[FollowListTableViewController alloc]init];
    flVc.vcTitle = @"我关注的人";
    flVc.flag = @"follow";
    [[self getCurrentViewController].navigationController pushViewController:flVc animated:YES];
    [self getCurrentViewController].hidesBottomBarWhenPushed = NO;
    
}

// 粉丝列表
- (IBAction)fansList:(UIButton *)sender {
    NSLog(@"粉丝列表");
    
    [self getCurrentViewController].hidesBottomBarWhenPushed = YES;
    FollowListTableViewController *flVc = [[FollowListTableViewController alloc]init];
    flVc.vcTitle = @"我的粉丝";
    flVc.flag = @"fans";
    [[self getCurrentViewController].navigationController pushViewController:flVc animated:YES];
    [self getCurrentViewController].hidesBottomBarWhenPushed = NO;
}

@end
