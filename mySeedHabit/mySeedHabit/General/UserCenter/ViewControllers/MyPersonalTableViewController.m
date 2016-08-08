//
//  MyPersonalTableViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "MyPersonalTableViewController.h"
#import "UIColor+CJFColor.h"
#import "EditPersonalTableViewCell.h"
#import "SignedTableViewCell.h"
#import "ChangePasswordTableViewCell.h"

@interface MyPersonalTableViewController ()

@end

@implementation MyPersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self buildHeaderView];
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.title = self.titleStr;
    self.tableView.separatorStyle = NO;
    // 设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    // 设置导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.tableView.backgroundColor = RGB(245, 245, 245);
    // 编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditAction:)];
    UINib *nib1 = [UINib nibWithNibName:@"EditPersonalTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"personal"];
    UINib *nib2 = [UINib nibWithNibName:@"SignedTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"signed"];
    UINib *nib3 = [UINib nibWithNibName:@"ChangePasswordTableViewCell" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"change"];
}

#pragma mark 编辑按钮 -- 点击的是cell 不能控制点击cell中的textField
- (void)EditAction:(id)sender
{
    NSLog(@"111");
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:1];
    textField1.enabled = YES;
}

#pragma mark 创建tabieView的HeaderView
- (void)buildHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 120, 40)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"头像";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 60, 60)];
    imageView.image = [UIImage imageNamed:@"headerImage.jpg"];
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    [headerView addSubview:label];
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.tableView.tableHeaderView addGestureRecognizer:tapGeture];
}

#pragma mark 点击手势方法
- (void)tapAction
{
    NSLog(@"123");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        EditPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personal" forIndexPath:indexPath];
        cell.titleL.text = @"昵称";
        cell.descTF.text = @"大宝";
        [cell.descTF setTag:1];
        cell.descTF.enabled = NO;
        // 设置选中cell颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
        return cell;
    }else if (indexPath.section == 1){
        SignedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signed" forIndexPath:indexPath];
        cell.signedL.text = @"性别";
        cell.signedTF.text = @"男";
        // 设置选中cell颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
        return cell;
    }else{
        ChangePasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"change" forIndexPath:indexPath];
        // 设置选中cell颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
        return cell;
    }
}

@end
