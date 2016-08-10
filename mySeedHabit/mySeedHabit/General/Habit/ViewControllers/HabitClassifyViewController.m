//
//  HabitClassifyViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitClassifyViewController.h"
#import "Masonry.h"
#import "TabPageScrollView.h"

@interface HabitClassifyViewController ()

@property (nonatomic,strong)TabPageScrollView *pageScrollView;

@end

@implementation HabitClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (void)buildUI
{
    self.title = @"习惯分类";
    UITableView *tabView1 = [UITableView new];
    UITableView *tabView2 = [UITableView new];
    UITableView *tabView3 = [UITableView new];
    UITableView *tabView4 = [UITableView new];
    UITableView *tabView5 = [UITableView new];
    UITableView *tabView6 = [UITableView new];
    NSArray *pageItems = @[
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"热门" andTabView:tabView1],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"健康" andTabView:tabView2],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"运动" andTabView:tabView3],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"学习" andTabView:tabView4],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"效率" andTabView:tabView5],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"思考" andTabView:tabView6]
                           ];
    _pageScrollView = [[TabPageScrollView alloc]initWithPageItems:pageItems];
    UIView *rootView = self.view;
    [rootView addSubview:_pageScrollView];
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView.mas_top);
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
    }];
    // 自定义返回按钮 详情
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"YQNleft_32.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


@end
