//
//  HabitCheckInViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitCheckInViewController.h"
//#import "CheckTabPageScrollView.h"
#import "Masonry.h"

@interface HabitCheckInViewController ()<UITableViewDataSource,UITableViewDelegate,TabPageScrollViewDelegate>

@property (nonatomic,strong)CheckTabPageScrollView *pageScrollView;
@property (nonatomic,strong)UITableView *statisticsTableView;
@property (nonatomic,strong)UITableView *growTableView;
@property (nonatomic,strong)UITableView *rankingTableView;

@end

@implementation HabitCheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self buildUI];
}

- (void)buildUI
{
    self.statisticsTableView = [self createTableViewWithIndentifier:@"statistics"];
    self.growTableView = [self createTableViewWithIndentifier:@"grow"];
    self.rankingTableView = [self createTableViewWithIndentifier:@"ranking"];
    
    NSArray *pagrItems = @[
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"统计" andTabView:self.statisticsTableView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"生长" andTabView:self.growTableView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"排行" andTabView:self.rankingTableView]
                           ];
    _pageScrollView = [[CheckTabPageScrollView alloc]initWithPageItems:pagrItems];
    self.view.backgroundColor = RGB(255, 255, 255);
    UIView *rootView = self.view;
    [rootView addSubview:_pageScrollView];
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView.mas_top);
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        // 隐藏tabar要减掉tabar的高度
        make.bottom.equalTo(rootView.mas_bottom).offset(49);
    }];
}

- (UITableView *)createTableViewWithIndentifier:(NSString *)identifier
{
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    return tableView;
}




@end
