//
//  EditPersonalTableViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "EditPersonalTableViewController.h"
#import "UIColor+CJFColor.h"
#import "EditPersonalTableViewCell.h"

@interface EditPersonalTableViewController ()

@end

@implementation EditPersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self buildHeaderView];
}

- (void)createTableView
{
    self.navigationItem.title = @"我的资料";
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tableView.separatorStyle = NO;
    // 设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    // 设置导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.tableView registerClass:[EditPersonalTableViewCell class] forCellReuseIdentifier:@"personal"];
    UINib *nib = [UINib nibWithNibName:@"EditPersonalTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"edit"];
}

#pragma mark 创建tableView头视图
- (void)buildHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 80)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 120, 40)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"头像";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 60, 60)];
    imageView.image = [UIImage imageNamed:@"headerImage.jpg"];
    [headerView addSubview:label];
    [headerView addSubview:imageView];
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.tableView.tableHeaderView addGestureRecognizer:tapGeture];
}

- (void)tapAction
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"edit" forIndexPath:indexPath];
    cell.nameLabel.text = @"昵称";
    cell.descLabel.text = @"大宝";
    return cell;
}

@end
