//
//  HabitJoinViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitJoinViewController.h"

@interface HabitJoinViewController ()

@end

@implementation HabitJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

#pragma mark 创建UI界面
- (void)buildUI
{
    self.title = @"习惯设置";
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 15, 50, 30);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem = finishItem;
}

#pragma mark 完成按钮点击方法
- (void)finishAction
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"habit_id":@(self.newHabit_id),
                                 @"user_id":@1850869,
                                 @"private":@2
                                 };
    [session POST:APISetPrivateHabit parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"刷新添加习惯成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"刷新添加习惯失败");
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
    // TODO:添加完的习惯跳到第一个页面时要刷新显示出来
}

@end
