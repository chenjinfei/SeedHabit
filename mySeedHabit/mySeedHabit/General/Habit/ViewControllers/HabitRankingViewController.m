//
//  HabitRankingViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitRankingViewController.h"
#import "HabitUsersModel.h"
#import "HabitRankingCell.h"
#import <UIImageView+WebCache.h>
#import "UserManager.h"
#import "SeedUser.h"
#import "UserCenterViewController.h"

@interface HabitRankingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *numArr;
@property (nonatomic,strong)SeedUser *user;

@end

@implementation HabitRankingViewController

- (NSMutableArray *)usersArr
{
    if (_usersArr == nil) {
        _usersArr = [NSMutableArray array];
    }
    return _usersArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self getData];
    self.user = [[UserManager manager] currentUser];
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.title = @"达人榜";
    self.numArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"HabitRankingCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ranking"];
}

#pragma mark 获取网络数据
- (void)getData
{
    NSInteger num = [self.habit_idStr integerValue];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"habit_id":@(num),
                                 @"num":@30,
                                 @"page":@0
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/Habit/getExpertList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"users"]) {
//            HabitUsersModel *users = [[HabitUsersModel alloc]init];
            SeedUser *users = [[SeedUser alloc]init];
            [users setValuesForKeysWithDictionary:dic];
            [self.usersArr addObject:users];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArr.count;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HabitRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ranking" forIndexPath:indexPath];
    SeedUser *users = self.usersArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.user = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"goldCup.png"];
        return cell;
    }else if (indexPath.row == 1) {
        cell.user = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"silverCup.png"];
        return cell;
    }else if (indexPath.row == 2) {
        cell.user = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"copperCup.png"];
        return cell;
    }else{
        // 防止重用池重复引用问题,从第4行开始要把cupL的image置为nil
        cell.cupL.image = nil;
        cell.user = users;
        cell.numberL.text = self.numArr[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserCenterViewController *uVc = [[UserCenterViewController alloc]init];
    SeedUser *tUser = (SeedUser *)self.usersArr[indexPath.row];
    uVc.user = tUser;
    [self.navigationController pushViewController:uVc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}



@end
