//
//  LeftViewController.m
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "MyPersonalTableViewController.h"
#import "MyConcernTableViewController.h"
#import "LogoutTableViewCell.h"
#import "HeaderView.h"


@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self buildHeaderView];
}

#pragma mark 创建tableView
- (void)createTableView
{
    NSMutableArray *dataArray1 = [[NSMutableArray alloc]initWithObjects:@"我的资料",@"我的关注",@"我的收藏", nil];
    NSMutableArray *dataArray2 = [[NSMutableArray alloc]initWithObjects:@"帮助中心",@"消息提醒设置", nil];
    NSMutableArray *dataArray3 = [[NSMutableArray alloc]initWithObjects:@"关于种子习惯", nil];
    NSMutableArray *dataArray4 = [[NSMutableArray alloc]initWithObjects:@"退出登录", nil];
    self.dataArray = [[NSMutableArray alloc]initWithObjects:dataArray1,dataArray2,dataArray3,dataArray4, nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:0];
    self.tableView.backgroundColor = RGB(245, 245, 245);
    self.tableView.separatorStyle = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"LogoutTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"logout"];
}

#pragma mark 创建tableView头视图
- (void)buildHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    HeaderView *header = [[HeaderView alloc]init];
    [header setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [headerView addSubview:header];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        LogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logout"];
        // 设置选中cell颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"reuse"];
        }
        [[cell textLabel] setText:[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        // 设置选中cell颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
        return cell;
    }
}

#pragma mark 点击cell响应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                MyPersonalTableViewController *MyPersonalVC = [[MyPersonalTableViewController alloc]init];
                MyPersonalVC.titleStr = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                [[DrawerViewController shareDrawer]turnToViewController:MyPersonalVC];
            }else if (indexPath.row == 1){
                MyConcernTableViewController *MyConcernVC = [[MyConcernTableViewController alloc]init];
                MyConcernVC.titleStr = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                [[DrawerViewController shareDrawer]turnToViewController:MyConcernVC];
            }else{
                
            }
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
            
            break;
        }
        case 4:{
            
            break;
        }
            
        default:
            break;
    }
    // 取消选中状态,取消cell选中颜色
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
