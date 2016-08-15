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

@interface HabitRankingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *numArr;

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
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.title = @"达人榜";
    self.numArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
            HabitUsersModel *users = [[HabitUsersModel alloc]init];
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
    HabitUsersModel *users = self.usersArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.users = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"goldCup.png"];
        return cell;
    }else if (indexPath.row == 1) {
        cell.users = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"silverCup.png"];
        return cell;
    }else if (indexPath.row == 2) {
        cell.users = users;
        cell.numberL.text = self.numArr[indexPath.row];
        cell.cupL.image = [UIImage imageNamed:@"copperCup.png"];
        return cell;
    }else{
        // 防止重用池重复引用问题,从第4行开始要把cupL的image置为nil
        cell.cupL.image = nil;
        cell.users = users;
        cell.numberL.text = self.numArr[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark cell显示时动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义3D旋转对象:4阶矩阵
    CATransform3D rotation;
    // 3D旋转对象初始化/角度控制
    rotation = CATransform3DMakeRotation(90.0*M_PI/180, 0.0, 0.7, 0.4);
    // 逆时针旋转
    rotation.m34 = 1.0/-600;
    cell.contentView.layer.transform = rotation;
    cell.contentView.layer.anchorPoint = CGPointMake(0,0.5);
    [UIView animateWithDuration:0.8 animations:^{
        cell.contentView.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
    }];
}



@end
