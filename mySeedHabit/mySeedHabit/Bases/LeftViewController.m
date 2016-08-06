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
#import "EditPersonalTableViewController.h"
#import "MyConcernTableViewController.h"


@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LeftViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithObjects:@"我的关注",@"我的收藏",@"帮助中心",@"消息提醒设置",@"关于种子习惯", nil];
    }
    // 编辑个人资料
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self buildHeaderView];
}

- (void)createTableView
{
    self.view.backgroundColor = RGB(0, 176, 137);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-100) style:0];
    self.tableView.separatorStyle = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark 创建tableView头视图
- (void)buildHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 80)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 120, 40)];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"编辑个人资料";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 10, 60, 60)];
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
    EditPersonalTableViewController *EditPersonalVC = [[EditPersonalTableViewController alloc]init];
    [[DrawerViewController shareDrawer] turnToViewController:EditPersonalVC];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"reuse"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            MyConcernTableViewController *MyConcernVC = [[MyConcernTableViewController alloc]init];
            MyConcernVC.titleStr = self.dataArray[indexPath.row];
            [[DrawerViewController shareDrawer]turnToViewController:MyConcernVC];
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
}



@end
