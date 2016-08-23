//
//  HabitDetailsViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitDetailsViewController.h"

#import "HabitNoteModel.h"
#import "HabitNotesModel.h"
#import "HabitPropsModel.h"
#import "HabitCommentsModel.h"
#import "HabitUsersModel.h"
#import "HabitHabitsModel.h"
#import "HabitCheckInModel.h"
#import "HabitNotesByTimeCell.h"
#import "HabitCheckInCell.h"
#import "HabitCheckModel.h"
#import "HabitCheckInViewController.h"
#import "AddNoteViewController.h"
#import "DiscoveTableViewCell.h"


// SDWebImage可以设置为button加背景照片
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "MJRefresh.h"
#import "Masonry.h"
#import "CJFTools.h"
#import "SeedUser.h"
#import "UserManager.h"


#import "HabitGrowStatisticsView.h"
#import "NSString+CJFString.h"

@interface HabitDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)DiscoveTableViewCell *cell;
@property (nonatomic,strong)NSMutableArray *notesArr;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *habitsArr;
@property (nonatomic,strong)NSMutableArray *checkArr;
@property (nonatomic,strong)NSMutableArray *is_check_inArr;
@property (nonatomic,strong)NSString *check_in_idStr;

// 是否下拉刷新
@property (nonatomic,assign)BOOL isRefresh;
// 是否上拉加载
@property (nonatomic,assign)BOOL isFlag;
@property (nonatomic,strong)NSString *nextId;

// 存储评论数据
@property (nonatomic,strong)NSMutableString *commentStr;
@property (nonatomic,strong)UIButton *checkBtn;

// 生长统计视图
@property (nonatomic, strong) UIView *growStatisticsView;

@end


// 上拉加载需要另外的一个数据
static NSString *nextStr = nil;
// 控制签到背景图片
static BOOL Flag = 0;

@implementation HabitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[UserManager manager] currentUser];
    // 创建视图
    [self createTableView];
    
//     配置下拉刷新控件
    [self TableViewRefresh];
    self.isFlag = 0;
    self.isRefresh = 1;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // 获取一个星期的签到情况, 并在此方法中显示当天是否已经签到
    [self getLastWeekCheck];
    
    [self LoadData];
    
}


#pragma mark 刷新加载控件
- (void)TableViewRefresh
{
    // 弱引用,可以在里面更改self
    __weak typeof(self) weakSelf = self;
    // 默认block方法:设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isRefresh = 0;
        self.isFlag = 0;
        [weakSelf LoadData];
    }];
    // 默认block方法:设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.isFlag = 1;
        self.isRefresh = 1;
        [weakSelf LoadData];
    }];
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.title = self.titleStr;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    // 自定义工具按钮
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(0, 0, 30, 30);
    [toolBtn setImage:[UIImage imageNamed:@"tools_white_32.png"] forState:UIControlStateNormal];
    [toolBtn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem = [[UIBarButtonItem alloc]initWithCustomView:toolBtn];
    self.navigationItem.rightBarButtonItem = toolItem;
    
    // 创建tableHeaderView
    UIView *tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 388)];
    self.tableView.tableHeaderView = tableHeader;
    
    // 创建当天的签到按钮
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    headerView.backgroundColor = [UIColor whiteColor];
    [tableHeader addSubview:headerView];
    
    UILabel *todayView = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    [headerView addSubview:todayView];
    todayView.font = [UIFont systemFontOfSize:14];
    todayView.textColor = [UIColor lightGrayColor];
    todayView.textAlignment = NSTextAlignmentCenter;
    //获取系统当前的时间戳
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSString *todayStr = [[CJFTools manager] revertTimeamp:[NSString stringWithFormat:@"%f", now] withFormat:@"MM月dd日"];
    todayView.text = todayStr;
    
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkBtn setImage:[UIImage imageNamed:@"check_in2.png"] forState:UIControlStateNormal];
    [self.checkBtn setImage:[UIImage imageNamed:@"check_in1.png"] forState:UIControlStateSelected];
    [self.checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.checkBtn];
    
    self.checkBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.4, SCREEN_WIDTH*0.4);
    self.checkBtn.center = headerView.center;
    
    // 生长统计
    UIView *growView = [[[NSBundle mainBundle] loadNibNamed:@"HabitGrowStatisticsView" owner:self options:nil] lastObject];
    growView.frame = CGRectMake(0, 250, SCREEN_WIDTH, 138);
    [self.tableView.tableHeaderView addSubview:growView];
    self.growStatisticsView = growView;
    
    // 添加手势
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(grow:)];
    growView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    [growView addGestureRecognizer:Tap];
    
    
}

#pragma mark 添加手势方法
- (void)grow:(UITapGestureRecognizer *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    HabitCheckInViewController *checkInVC = [[HabitCheckInViewController alloc]init];
    checkInVC.user = self.user;
    checkInVC.habit_idStr = self.habit_idStr;
    checkInVC.check_in_times = self.check_in_times;
    checkInVC.members = self.members;
    checkInVC.join_days = self.join_days;
    [self.navigationController pushViewController:checkInVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark 获取心情列表数据
- (void)getNotesByTimeData
{
    
}


// 工具响应方法
- (void)toolAction:(id)sender
{
    NSLog(@"工具响应方法");
}

#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.cell Height];
    return height + 140;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notesArr.count;
}

#pragma mark 返回cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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


#pragma mark 获取签到数据
- (void)checkAction
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    AddNoteViewController *addNoteVC = [[AddNoteViewController alloc]init];
    addNoteVC.habit_idStr = self.habit_idStr;
    // 当地时间转换为时间戳
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
    NSLog(@"%@",localeDate);
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    // 得到的时间戳再减掉8个小时
    NSInteger delta = [zone secondsFromGMT];
    NSInteger timeTemp = [timeSp integerValue] - delta;
    NSInteger num = [self.habit_idStr integerValue];
    NSDictionary *parameter = @{
                                @"check_in_time":@(timeTemp),
                                @"habit_id":@(num),
                                @"time_zone":@0,
                                @"user_id": [NSString stringWithFormat:@"%@", self.user.uId]
                                };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/CheckIn/checkIn" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 判断签到相应的情况,当没签到且没有错误信息时才能签到
        if ([responseObject[@"status"] integerValue] == 0 && responseObject[@"data"] != nil) {
            NSLog(@"666666666");
            // 选中状态切换背景图片
            self.checkBtn.selected = YES;
            Flag = 1;
            // 当签到成功后获取到相应的参数数据(check_in_id),再push到下一页
            addNoteVC.check_in_id = responseObject[@"data"][@"check_in"][@"id"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addNoteVC animated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 获取一个星期的签到情况
- (void)getLastWeekCheck
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger num = [self.habit_idStr integerValue];
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
    //    NSLog(@"%@",localeDate);
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    // 得到的时间戳再减掉8个小时
    NSInteger delta = [zone secondsFromGMT];
    NSInteger timeTemp = [timeSp integerValue] - delta;
    NSDictionary *parameter = @{
                                @"habit_id":@(num),
                                @"next_check_in_time":@(timeTemp),
                                @"user_id": [NSString stringWithFormat:@"%@", self.user.uId]
                                };
    [session POST:APILastWeekCheckIn parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"data"]) {
            
            //获取系统当前的时间戳
            NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
            NSString *todayStr = [[CJFTools manager] revertTimeamp:[NSString stringWithFormat:@"%f", now] withFormat:@"yy/MM/dd"];
            
            BOOL isCheckToday = NO;
            
            for (NSDictionary *dic in responseObject[@"data"][@"check_ins"]) {
                
                HabitCheckModel *check = [[HabitCheckModel alloc]init];
                [check setValuesForKeysWithDictionary:dic];
                [self.checkArr addObject:check];
                
                // 遍历本周签到数据，判断当天是否已经签到
                NSString *dayStr = [[CJFTools manager] revertTimeamp:check.check_in_time withFormat:@"yy/MM/dd"];
                if (check.is_check_in) {
                    
                    if ([todayStr isEqualToString:dayStr]) {
                        isCheckToday = YES;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.checkBtn.selected = isCheckToday;
                
                for (int i = 0; i < self.checkArr.count; i++) {
                    HabitCheckModel *check = self.checkArr[i];
                    if (check.is_check_in) {
                        NSInteger index = [NSString getWeekDayForTimeamp:[check.check_in_time integerValue]];
                        UIButton *btn = (UIButton *)[self.growStatisticsView viewWithTag:index];
                        if (btn) {
                            btn.selected = YES;
                        }
                    }
                }
                
                // 显示坚持天数
                UILabel *check_in_timeL = [self.growStatisticsView valueForKey:@"holdTimeView"];
                NSString *check_in_times = [NSString stringWithFormat:@"已坚持%ld天",(long)[self.check_in_times integerValue]];
                check_in_timeL.text = check_in_times;
                
            });
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark 点击cell响应方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark 获取动态网络
- (void)LoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSNumber *flag = [NSNumber numberWithBool:self.isFlag];
    NSInteger next_id;
    if (self.isFlag == 1) {
        next_id = [self.nextId integerValue];
        next_id--;
    }
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"habit_id": self.habit_idStr,
                                 @"next_id":@(next_id),
                                 @"user_id":self.user.uId
                                 };
    
    [session POST:APIHabitNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
        
             NSLog(@"%@", responseObject);
            __weak typeof (self) weakSelf = self;
            [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.notesArr UsersArr:weakSelf.usersArr HabitsArr:weakSelf.habitsArr isRefresh:self.isRefresh tableView:self.tableView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
//                [self.mReadStr appendFormat:@"%@|", [note valueForKey:@"id"]];
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





#pragma mark 懒加载

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
- (NSMutableArray *)is_check_inArr
{
    if (_is_check_inArr == nil) {
        _is_check_inArr = [NSMutableArray array];
    }
    return _is_check_inArr;
}

- (NSMutableArray *)checkArr
{
    if (_checkArr == nil) {
        _checkArr = [NSMutableArray array];
    }
    return _checkArr;
}

@end
