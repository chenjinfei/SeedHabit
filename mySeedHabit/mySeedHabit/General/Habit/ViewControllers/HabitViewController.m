//
//  HabitViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitViewController.h"
#import "UserManager.h"
#import "LoginViewController.h"
#import "HabitTableViewCell.h"
#import "HabitListModel.h"
#import "HabitClassifyViewController.h"
#import "HabitDetailsViewController.h"

@interface HabitViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *habiesArray;

// 传到添加习惯页面所需要的习惯数组
@property (nonatomic,strong)NSMutableArray *habitNameArr;

@end

@implementation HabitViewController

- (NSMutableArray *)habiesArray
{
    if (_habiesArray == nil) {
        _habiesArray = [NSMutableArray array];
    }
    return _habiesArray;
}

- (NSMutableArray *)habitNameArr
{
    if (_habitNameArr == nil) {
        _habitNameArr = [NSMutableArray array];
    }
    return _habitNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self createTableView];
}

#pragma mark 获取网络数据
- (void)getData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"user_id":@1850869
                                 };
    [session POST:APIHabitList parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 添加习惯后要清楚原有的习惯再重新从习惯接口获取数据
        [self.habiesArray removeAllObjects];
        [self.habitNameArr removeAllObjects];
        for (NSDictionary *dic in responseObject[@"data"][@"habits"]) {
            HabitListModel *habits = [[HabitListModel alloc]init];
            [habits setValuesForKeysWithDictionary:dic];
            [self.habiesArray addObject:habits];
            [self.habitNameArr addObject:habits.name];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++%@",error);
    }];
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.navigationController.navigationBar.translucent = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"HabitTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"hh"];
    // 编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // 自定义进入按钮
    UIButton *intoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    intoBtn.frame = CGRectMake(0, 0, 30, 30);
    [intoBtn setImage:[UIImage imageNamed:@"into_32.png"] forState:UIControlStateNormal];
    [intoBtn addTarget:self action:@selector(intoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *intoItem = [[UIBarButtonItem alloc]initWithCustomView:intoBtn];
    self.navigationItem.rightBarButtonItem = intoItem;
}

#pragma mark 点击进入习惯分类页面
- (void)intoAction:(id)sender
{
    HabitClassifyViewController *HabitClassifyVC = [[HabitClassifyViewController alloc]init];
    HabitClassifyVC.habitArr = self.habitNameArr;
    [self.navigationController pushViewController:HabitClassifyVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.habiesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HabitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hh"];
    HabitListModel *habits = self.habiesArray[indexPath.row];
    cell.habit = habits;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HabitDetailsViewController *habitDetailsVC = [[HabitDetailsViewController alloc]init];
    HabitListModel *habits = self.habiesArray[indexPath.row];
    habitDetailsVC.titleStr = habits.name;
    // 不能用点语法  把习惯id跟标题一起传过去
    habitDetailsVC.habit_idStr = [habits valueForKey:@"idx"];
    // 传坚持习惯的天数
    habitDetailsVC.check_in_times = [habits valueForKey:@"check_in_time"];
    // 隐藏下一页的tabar
    self.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:habitDetailsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark 让tableView可以编辑
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

#pragma mark 使cell处于编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 处理编辑结果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    HabitListModel *habit = self.habiesArray[indexPath.row];
    NSString *habit_idStr = [habit valueForKey:@"idx"];
    NSInteger idNum = [habit_idStr integerValue];
    NSDictionary *parameter = @{
                                @"habit_id":@(idNum),
                                @"user_id":@1850869
                                };
    [session POST:APIQuitHabit parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除失败");
    }];
    // 删除数据
    [self.habiesArray removeObjectAtIndex:indexPath.row];
    // 删除视图
    [self.tableView reloadData];
}

#pragma mark 设置可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 编辑移动过程中数据排序问题
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

#pragma mark 将要显示时调用此方法
- (void)viewWillAppear:(BOOL)animated
{
    // 添加习惯后要重新获取数据,不是在viewDidLoad中写
    [self getData];
    [self.tableView reloadData];
}

@end

