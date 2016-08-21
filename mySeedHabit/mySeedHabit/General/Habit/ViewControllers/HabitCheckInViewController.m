//
//  HabitCheckInViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitCheckInViewController.h"
#import "TabPageScrollView.h"
#import "Masonry.h"
#import "CalendarDateView.h"
#import "HabitCheckInModel.h"
#import "CJFTools.h"
#import "AllCheckInListCell.h"
#import "HabitRankingViewController.h"
#import "HabitUsersModel.h"
#import "HabitRankingCell.h"
#import "UserManager.h"
#import "SeedUser.h"
#import "TreeInfo.h"
#import <UIImageView+WebCache.h>
#import "Masonry.h"

@interface HabitCheckInViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *allCheckInArr;
@property (nonatomic,strong)NSMutableArray *treeInfoArr;
@property (nonatomic,strong)NSMutableArray *expertArr;
@property (nonatomic,strong)UITableView *expertTableView;
@property (nonatomic,strong)TabPageScrollView *pageScrollView;
@property (nonatomic,strong)UITableView *calendarTableView;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSMutableArray *numArr;
@property (nonatomic,strong)SeedUser *user;

@property (nonatomic,strong)UILabel *note;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UIImageView *treeImage;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int day;
@property (nonatomic,assign)int hour;
@property (nonatomic,assign)int minute;
@property (nonatomic,assign)int second;
@property (nonatomic,strong)CalendarDateView *calendarView;
@property (nonatomic,strong)TreeInfo *tree;

@end

@implementation HabitCheckInViewController

- (NSMutableArray *)allCheckInArr
{
    if (_allCheckInArr == nil) {
        _allCheckInArr = [NSMutableArray array];
    }
    return _allCheckInArr;
}

- (NSMutableArray *)treeInfoArr
{
    if (_treeInfoArr == nil) {
        _treeInfoArr = [NSMutableArray array];
    }
    return _treeInfoArr;
}

- (NSMutableArray *)expertArr
{
    if (_expertArr == nil) {
        _expertArr = [NSMutableArray array];
    }
    return _expertArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAllCheckInList];
    [self getExpertList];
    [self getTreeInfo];
    [self buildUI];
    self.user = [[UserManager manager] currentUser];
}


- (void)buildUI
{
    // 创建日历
    self.calendarView = [[CalendarDateView alloc]init];
    self.calendarView.frame = CGRectMake(15, 74, SCREEN_WIDTH - 20, SCREEN_WIDTH*0.6);
    //********创建统计界面
    self.title = @"签到统计";
    self.calendarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.calendarTableView.separatorStyle = NO;
    self.calendarTableView.tableHeaderView = self.calendarView;
    self.calendarTableView.backgroundColor = RGB(255, 255, 255);
    self.calendarTableView.dataSource = self;
    self.calendarTableView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"AllCheckInListCell" bundle:nil];
    [self.calendarTableView registerNib:nib forCellReuseIdentifier:@"allCheckInList"];
    
    
    //*******创建生长界面
    UIView *getTreeInfoView = [[UIView alloc]init];
    getTreeInfoView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-40);
    getTreeInfoView.backgroundColor = [UIColor whiteColor];
    self.note = [[UILabel alloc]init];
    self.note.textAlignment = NSTextAlignmentCenter;
    self.note.font = [UIFont systemFontOfSize:15];
    [getTreeInfoView addSubview:self.note];
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getTreeInfoView.mas_top).offset(30);
        make.left.equalTo(getTreeInfoView.mas_left).offset(10);
        make.right.equalTo(getTreeInfoView.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    self.treeImage = [[UIImageView alloc]init];
    [getTreeInfoView addSubview:self.treeImage];
    [self.treeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.note.mas_bottom).offset(20);
        make.centerX.equalTo(getTreeInfoView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.8, SCREEN_WIDTH*0.8));
    }];
    
    self.time = [[UILabel alloc]init];
    self.time.textAlignment = NSTextAlignmentCenter;
    [getTreeInfoView addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(getTreeInfoView.mas_left).offset(10);
        make.right.equalTo(getTreeInfoView.mas_right).offset(-10);
        make.top.equalTo(self.treeImage.mas_bottom).offset(20);
        make.height.equalTo(@30);
    }];
    
    
    //*******创建排行榜
    self.expertTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-40) style:UITableViewStylePlain];
    self.numArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    self.expertTableView.separatorStyle = NO;
    self.expertTableView.dataSource = self;
    self.expertTableView.delegate = self;
    UINib *nib1 = [UINib nibWithNibName:@"HabitRankingCell" bundle:nil];
    [self.expertTableView registerNib:nib1 forCellReuseIdentifier:@"ranking"];
    
    NSArray *pageItems = @[
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"统计" andTabView:self.calendarTableView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"生长" andTabView:getTreeInfoView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"排行" andTabView:self.expertTableView]
    ];
    _pageScrollView = [[TabPageScrollView alloc]initWithPageItems:pageItems];
    _pageScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageScrollView];
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        // 隐藏tabar要减掉tabar的高度
        make.bottom.equalTo(self.view.mas_bottom).offset(49);
    }];
    // 自定义返回按钮 详情
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"left_32.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark 返回按钮方法
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取统计数据
- (void)getAllCheckInList
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger habitId = [self.habit_idStr integerValue];
    NSDictionary *parameter = @{
                                @"habit_id":@(habitId),
                                @"user_id":@1878988
                                };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/CheckIn/getAllCheckInList" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"check_ins"]) {
            HabitCheckInModel *checkModel = [[HabitCheckInModel alloc]init];
            [checkModel setValuesForKeysWithDictionary:dic];
            [self.allCheckInArr addObject:checkModel];
        }
        
        // 如果签到的数组不为空则给相应签到的日期赋值,如果没签到则直接创建空日历
        if (self.allCheckInArr.count > 0) {
            // 日历
            NSDate *date;
            NSMutableArray *signArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.allCheckInArr) {
                // 获取所有签到过的日期,时间戳转换为NSDate,再转换为NSDateComponents类型
                NSString *timeStr = [dic valueForKey:@"check_in_time"];
                NSTimeInterval timeI = [timeStr doubleValue];
                date = [NSDate dateWithTimeIntervalSince1970:timeI];
                NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
                [signArray addObject:[NSNumber numberWithLong:[comp day]]];
            }
            self.calendarView.signArray = signArray;
            // 当地时间
            self.calendarView.date = [NSDate date];
            NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
            //日期点击事件
            __weak typeof(CalendarDateView) *weakDemo = self.calendarView;
            self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
                if ([comp day]==day) {
                    //根据自己逻辑条件 设置今日已经签到的style 没有签到不需要写
                    [weakDemo setStyle_Today_Signed:weakDemo.dayButton];
                }
            };
        }else{
            self.calendarView.date = [NSDate date];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 添加计时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark 计时器方法
- (void)timerAction
{
    self.second++;
    if (self.second == 60) {
        self.second = 0;
        self.minute++;
        if (self.minute == 60) {
            self.minute = 0;
            self.hour++;
            if (self.hour == 24) {
                self.hour = 0;
                self.day++;
            }
        }
    }
    NSLog(@"+++++++%@",self.time.text);
    self.time.text = [NSString stringWithFormat:@"%d : %02d : %02d : %02d", self.day, self.hour, self.minute, self.second];
}

#pragma mark 离开时停止计时器
- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 获取生长树数据
- (void)getTreeInfo
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger habitId = [self.habit_idStr integerValue];
    NSDictionary *parameter = @{
                                 @"habit_id":@(habitId),
                                 @"user_id":@1878988
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/mindNote/getTreeInfo" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.tree = [[TreeInfo alloc] init];
        self.tree = responseObject[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           self.note.text = [self.tree valueForKey:@"note"];
           [self.treeImage sd_setImageWithURL:[NSURL URLWithString:[self.tree valueForKey:@"tree_address"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
           // 时间戳转换
           // 用户发表时间
           NSString *timeS = [NSString stringWithFormat:@"%@", [self.tree valueForKey:@"start_time"]];
            if ([[self.tree valueForKey:@"grow_day"] integerValue] == 0) {
                self.time.text = [NSString stringWithFormat:@"%d : %02d : %02d : %02d", 00, 00, 00, 00];
            }else{
                [self addTimer];
            }
           NSTimeInterval time = [timeS doubleValue];
           NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
           NSDate *new = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
           NSTimeInterval interval = [new timeIntervalSinceDate:detail];
           
           self.second = (int)interval % 60;
           self.minute = (int)interval / 60 %60;
           self.hour = (int)interval / 3600 %24;
           self.day = (int)interval / 3660/24;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
}

#pragma mark 获取排行榜数据
-(void)getExpertList
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger habitId = [self.habit_idStr integerValue];
    NSDictionary *parameter = @{
                                @"habit_id":@(habitId),
                                @"num":@30,
                                @"page":@0
                                };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/Habit/getExpertList" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"users"]) {
            HabitUsersModel *users = [[HabitUsersModel alloc]init];
            [users setValuesForKeysWithDictionary:dic];
            [self.expertArr addObject:users];
        };
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.expertTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 分区头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.calendarTableView]) {
        NSString *str = [NSString stringWithFormat:@"%@",@"数据统计"];
        return str;
    }else{
        return nil;
    }
}


#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.calendarTableView]) {
        return 50;
    }
    if ([tableView isEqual:self.expertTableView]) {
        return 80;
    }
    return 0;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.calendarTableView]) {
        return 3;
    }
    if ([tableView isEqual:self.expertTableView]) {
        return self.expertArr.count;
    }
    return 0;
}

#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.calendarTableView]) {
        AllCheckInListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCheckInList"];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"总共加入天数";
            cell.detailLabel.text = self.join_days;
            cell.unitLabel.text = @"天";
        }
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"已坚持天数";
            cell.detailLabel.text = self.check_in_times;
            cell.unitLabel.text = @"天";
        }
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"参与人数";
            cell.detailLabel.text = self.members;
            cell.unitLabel.text = @"人";
        }
        cell.detailLabel.textColor = RGB(16,255,0);
        cell.unitLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([tableView isEqual:self.expertTableView]){
        HabitRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ranking" forIndexPath:indexPath];
        HabitUsersModel *users = self.expertArr[indexPath.row];
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
    }else{
        return nil;
    }
}

@end