//
//  HabitJoinViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitJoinViewController.h"
#import "JoinHabitCell.h"
#import "UserManager.h"
#import "SeedUser.h"
#import "UIColor+CJFColor.h"

@interface HabitJoinViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)SeedUser *user;

@end

@implementation HabitJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    [self buildUI];
    self.user = [[UserManager manager] currentUser];
}

#pragma mark 创建UI界面
- (void)buildUI
{
    self.title = @"习惯设置";
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    finishBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 15, 50, 30);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem = finishItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(255, 255, 255);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"JoinHabitCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"setup"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
}

#pragma mark 完成按钮点击方法
- (void)finishAction
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"habit_id":@(self.newHabit_id),
                                 @"user_id":[NSString stringWithFormat:@"%@", self.user.uId],
                                 @"private":@2
                                 };
    [session POST:APISetPrivateHabit parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"刷新添加习惯成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"刷新添加习惯失败");
    }];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    // TODO:添加完的习惯跳到第一个页面时要刷新显示出来
    self.hidesBottomBarWhenPushed = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark 分区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *hf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 20)];
    label.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        label.text = @"为刚刚添加的习惯设置闹钟提醒";
        [hf addSubview:label];
    }else{
        label.text = @"您可以选择是否将该习惯公开";
        [hf addSubview:label];
    }
    return hf;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JoinHabitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setup"];
    if (indexPath.section == 0) {
        cell.titleL.text = @"设置提醒";
        cell.descL.text = @"未设置";
    }else{
        cell.titleL.text = @"设置隐私习惯";
        cell.descL.text = @"自己可见";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
