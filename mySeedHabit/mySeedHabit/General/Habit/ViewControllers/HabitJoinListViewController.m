//
//  HabitJoinListViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitJoinListViewController.h"
#import "Masonry.h"
#import "HabitJoinViewController.h"
#import "HabitRankingViewController.h"

#import "HabitNoteModel.h"
#import "HabitNotesModel.h"
#import "HabitPropsModel.h"
#import "HabitCommentsModel.h"
#import "HabitUsersModel.h"
#import "HabitHabitsModel.h"

@interface HabitJoinListViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)CGFloat headerViewHeight;

@property (nonatomic,strong)NSMutableArray *notesArr;
@property (nonatomic,strong)NSMutableArray *commentsArr;
@property (nonatomic,strong)NSMutableArray *propsArr;
@property (nonatomic,strong)NSMutableArray *noteArr;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *habitsArr;
@end

@implementation HabitJoinListViewController

- (NSMutableArray *)noteArr
{
    if (_noteArr == nil) {
        _noteArr = [NSMutableArray array];
    }
    return _noteArr;
}
- (NSMutableArray *)notesArr
{
    if (_notesArr == nil) {
        _notesArr = [NSMutableArray array];
    }
    return _notesArr;
}
- (NSMutableArray *)commentsArr
{
    if (_commentsArr == nil) {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}
- (NSMutableArray *)usersArr
{
    if (_usersArr == nil) {
        _usersArr = [NSMutableArray array];
    }
    return _usersArr;
}
- (NSMutableArray *)propsArr
{
    if (_propsArr == nil) {
        _propsArr = [NSMutableArray array];
    }
    return _propsArr;
}
- (NSMutableArray *)habitsArr
{
    if (_habitsArr == nil) {
        _habitsArr = [NSMutableArray array];
    }
    return _habitsArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 如果用户对该习惯没有添加,则显示headerView,否则则隐藏headerView
    self.headerViewHeight = 100;
    for (NSString *habitStr in self.habitArray) {
        if ([habitStr isEqualToString:self.titleStr]) {
            self.headerViewHeight = 0;
        }
    }
    [self buildUI];
    [self buildTableView];
    [self getData];
}

#pragma mark 创建tableView上面的view
- (void)buildUI
{
    self.title = self.titleStr;
    self.headerView = [[UIView alloc]init];
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = RGB(255, 255, 255);    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.headerViewHeight));
    }];
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.text = self.titleStr;
    [self.headerView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(20);
        make.top.equalTo(self.headerView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150, 40));
    }];
    
    UILabel *membersL = [[UILabel alloc]init];
    NSString *str = [NSString stringWithFormat:@"%ld人在坚持",self.members];
    membersL.text = str;
    [self.headerView addSubview:membersL];
    [membersL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(10);
        make.left.equalTo(self.headerView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150, 40));
    }];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.backgroundColor = RGB(39, 169, 58);
    [joinBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [joinBtn setTitle:@"加入" forState:UIControlStateNormal];
    [self.headerView addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top).offset(35);
        make.right.equalTo(self.headerView.mas_right).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
}

#pragma mark 创建tableView
- (void)buildTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headerViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headerViewHeight) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 自定义工具按钮
    UIButton *cupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cupBtn.frame = CGRectMake(0, 0, 30, 30);
    [cupBtn setImage:[UIImage imageNamed:@"tool_32.png"] forState:UIControlStateNormal];
    [cupBtn addTarget:self action:@selector(cupAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cupItem = [[UIBarButtonItem alloc]initWithCustomView:cupBtn];
    self.navigationItem.rightBarButtonItem = cupItem;
}

#pragma mark 获取网络数据
- (void)getData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger num = [self.habit_idStr integerValue];
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":@0,
                                 @"habit_id":@(num),
                                 @"user_id":@1850869,
                                 };
    [session POST:APIHabitNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"habits"]) {
            HabitHabitsModel *habits = [[HabitHabitsModel alloc]init];
            [habits setValuesForKeysWithDictionary:dic];
            [self.habitsArr addObject:habits];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"++++%@",error);
    }];
}


- (void)cupAction
{
    HabitRankingViewController *rankingVC = [[HabitRankingViewController alloc]init];
    // TODO:此处有问题
    rankingVC.habit_idStr = [self.habitsArr[0] valueForKey:@"idx"];
    [self.navigationController pushViewController:rankingVC animated:YES];
}

#pragma mark 加入习惯点击方法 ranking
- (void)join
{
    HabitJoinViewController *joinVC = [[HabitJoinViewController alloc]init];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger num = [self.habit_idStr integerValue];
    joinVC.newHabit_id = num;
    NSDictionary *parameters = @{
                                 @"habit_id":@(num),
                                 @"user_id":@1850869
                                 };
    [session POST:APIJoinHabit parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"加入习惯成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加入习惯失败");
    }];
    [self.navigationController pushViewController:joinVC animated:YES];
}

@end
