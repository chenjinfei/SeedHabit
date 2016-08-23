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
#import <MJRefresh.h>

#import "HabitNoteModel.h"
#import "HabitNotesModel.h"
#import "HabitPropsModel.h"
#import "HabitCommentsModel.h"
#import "HabitUsersModel.h"
#import "HabitHabitsModel.h"

#import "Notes.h"
#import "Note.h"
#import "Habits.h"
#import "Users.h"

#import "UserManager.h"
#import "SeedUser.h"
#import "UIColor+CJFColor.h"
#import "DiscoveTableViewCell.h"
#import "DiscoverDetailViewController.h"

@interface HabitJoinListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)CGFloat headerViewHeight;

@property (nonatomic,strong)NSString *nextId;
// 存储loadData参数的数据
@property (nonatomic, strong) NSMutableString *mReadStr;

@property (nonatomic, strong)DiscoveTableViewCell *cell;
@property (nonatomic,strong)NSMutableArray *notesArr;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *habitsArr;

@property (nonatomic,strong)SeedUser *user;
@end

// 上拉加载
static BOOL isFlag = 0;
// 判断是否下拉刷新
static BOOL isRefresh = 1;

@implementation HabitJoinListViewController

- (NSMutableArray *)notesArr
{
    if (_notesArr == nil) {
        _notesArr = [NSMutableArray array];
    }
    return _notesArr;
}
- (NSMutableArray *)usersArr
{
    if (_usersArr == nil) {
        _usersArr = [NSMutableArray array];
    }
    return _usersArr;
}
- (NSMutableArray *)habitsArr
{
    if (_habitsArr == nil) {
        _habitsArr = [NSMutableArray array];
    }
    return _habitsArr;
}
- (NSMutableString *)mReadStr {

    if (_mReadStr == nil) {
        _mReadStr = [[NSMutableString alloc] init];
    }
    return _mReadStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    self.user = [[UserManager manager] currentUser];
    // 如果用户对该习惯没有添加,则显示headerView,否则则隐藏headerView
    self.headerViewHeight = 60;
    for (NSString *habitStr in self.habitArray) {
        if ([habitStr isEqualToString:self.titleStr]) {
            self.headerViewHeight = 0;
        }
    }
    [self buildUI];
    [self buildTableView];
    [self getData];
    
    [self TableViewRefresh];
}

#pragma mark 刷新加载控件
- (void)TableViewRefresh
{
    // 弱引用,可以在里面更改self
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    isFlag = 0;
    isRefresh = 0;
    // 默认block方法:设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        isFlag = 1;
        isRefresh = 1;
        [weakSelf getData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

#pragma mark 创建tableView上面的view
- (void)buildUI
{
    self.title = self.titleStr;
    self.headerView = [[UIView alloc]init];
    self.headerView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.headerViewHeight));
    }];
    
    UILabel *nameL = [[UILabel alloc]init];
    nameL.text = self.titleStr;
    nameL.textColor = [UIColor darkGrayColor];
    nameL.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(30);
        make.top.equalTo(self.headerView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150, 30));
    }];
    
    UILabel *membersL = [[UILabel alloc]init];
    NSString *str = [NSString stringWithFormat:@"%ld人在坚持",self.members];
    membersL.text = str;
    membersL.textColor = [UIColor lightGrayColor];
    membersL.font = [UIFont systemFontOfSize:13];
    [self.headerView addSubview:membersL];
    [membersL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(0);
        make.left.equalTo(self.headerView.mas_left).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150, 30));
    }];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    [joinBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [joinBtn setTitle:@"加入" forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top).offset(17);
        make.right.equalTo(self.headerView.mas_right).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
}

#pragma mark 创建tableView
- (void)buildTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headerViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headerViewHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    // 自定义工具按钮
    UIButton *cupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cupBtn.frame = CGRectMake(0, 0, 20, 20);
    [cupBtn setImage:[UIImage imageNamed:@"whiteCup_32.png"] forState:UIControlStateNormal];
    [cupBtn addTarget:self action:@selector(cupAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cupItem = [[UIBarButtonItem alloc]initWithCustomView:cupBtn];
    self.navigationItem.rightBarButtonItem = cupItem;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DiscoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Notes *notes = self.notesArr[indexPath.row];
    cell.usersArr = self.usersArr;
    cell.notes = notes;
    
    Note *note = notes.note;
    
    cell.propBtn.selected = NO;
    
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            cell.habits = habits;
        }
    }
    for (Users *users in self.usersArr) {
        if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
            cell.users = users;
            cell.userId.text = users.nickname;
        }
    }
    self.cell = cell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DiscoverDetailViewController *detailVC = [[DiscoverDetailViewController alloc] init];
    
    Notes *notes = self.notesArr[indexPath.row];
    Note *note = notes.note;
    
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            detailVC.habits = habits;
        }
    }
    
    for (Users *users in self.usersArr) {
        if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
            detailVC.users = users;
        }
    }
    detailVC.notes = notes;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.notesArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = [self.cell Height];
    return height+140;
    
}
- (void)viewWillDisappear:(BOOL)animated {

    self.nextId = nil;
    self.mReadStr = nil;
    
}
#pragma mark 获取网络数据
- (void)getData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSNumber *flag = [NSNumber numberWithBool:isFlag];
    NSString *readStr = self.mReadStr;
    NSInteger next_id = [self.nextId integerValue];
    if (isFlag == 1) {
        next_id = [self.nextId integerValue];
        next_id--;
    }

    
    NSInteger num = [self.habit_idStr integerValue];
    NSLog(@"%@",self.user.uId);
    NSLog(@"%ld", next_id);
    NSLog(@"%@", readStr);
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"habit_id":@(num),
                                 @"read_ids":readStr,
                                 @"next_time":@"",
                                 @"next_id":@(next_id),
                                 @"user_id":[NSString stringWithFormat:@"%@", self.user.uId]
                                 };
    [session POST:APIHabitNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 0) {
            
            NSLog(@"%@", responseObject);
            __weak typeof (self) weakSelf = self;
            [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.notesArr UsersArr:weakSelf.usersArr HabitsArr:weakSelf.habitsArr isRefresh:isRefresh tableView:self.tableView];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"++++%@",error);
    }];
}

// 解析数据
- (void)analysisDataWithResponseObject:(id)responseObject NotesArr:(NSMutableArray *)NotesArr UsersArr:(NSMutableArray *)UsersArr HabitsArr:(NSMutableArray *)HabitsArr isRefresh:(BOOL)isRefresh tableView:(UITableView *)tableView{
    
    //    __strong typeof(NotesArr) sNoteArr = NotesArr;
    
    
    
    // isRefresh == 0 上拉加载
    if (isRefresh == 1) {
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            [NotesArr addObject:notes];
            
            Note *note = dict[@"note"];
            // 上拉，加载
            //            if ([tableView isEqual:hotTabelView]) {
                            [self.mReadStr appendFormat:@"%@|", [note valueForKey:@"id"]];
            //            }
            //            else if ([tableView isEqual:newestTableView]) {
            //                self.NewNextId = [note valueForKey:@"id"];
            //            }
            //            else if ([tableView isEqual:keepTableView]){
            self.nextId = [note valueForKey:@"id"];
            //            }
            
        }
        
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [UsersArr addObject:users];
        }
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            [HabitsArr addObject:habits];
        }
    }
    
    else {
        
        NSMutableArray *notesArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            //            NSLog(@"%@", notes);
            if ([[[[NotesArr firstObject] valueForKey:@"note"] valueForKey:@"check_in_id"] isEqualToString:[[notes valueForKey:@"note"] valueForKey:@"check_in_id"]]) {
                break;
            }
            
            [notesArr addObject:notes];
        }
        NSArray *arr = [notesArr arrayByAddingObjectsFromArray:NotesArr];
        [NotesArr removeAllObjects];
        [NotesArr addObjectsFromArray:arr];
        
        
        NSMutableArray *userId = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in UsersArr) {
            [userId addObject:[dic valueForKey:@"uId"]]; // 获取当前所有用户的id
        }
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            // 如果没有 forin 的 id 就加入 数组
            if (![userId containsObject:[users valueForKey:@"uId"]]) {
                [usersArr addObject:users];
            }
        }
        NSArray *arr1 = [usersArr arrayByAddingObjectsFromArray:UsersArr];
        [UsersArr removeAllObjects];
        [UsersArr addObjectsFromArray:arr1];
        
        
        NSMutableArray *habitId = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in HabitsArr) {
            [habitId addObject:[dic valueForKey:@"idx"]];
        }
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            // 如果没有 forin 的 id 就加入 数组
            if (![habitId containsObject:[habits valueForKey:@"idx"]]) {
                [habitsArr addObject:habits];
            }
        }
        NSArray *arr2 = [habitsArr arrayByAddingObjectsFromArray:HabitsArr];
        [HabitsArr removeAllObjects];
        [HabitsArr addObjectsFromArray:arr2];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        // 数据加载完毕之后，结束更新
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        
    });
}

#pragma mark  跳转到排行榜页面
- (void)cupAction
{
    HabitRankingViewController *rankingVC = [[HabitRankingViewController alloc]init];
    rankingVC.habit_idStr = self.habit_idStr;
    self.hidesBottomBarWhenPushed = YES;
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
                                 @"user_id":[NSString stringWithFormat:@"%@", self.user.uId]
                                 };
    [session POST:APIJoinHabit parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"加入习惯成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"加入习惯失败");
    }];
    [self.navigationController pushViewController:joinVC animated:YES];
}

@end
