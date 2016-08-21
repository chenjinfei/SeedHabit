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


// SDWebImage可以设置为button加背景照片
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "MJRefresh.h"
#import "Masonry.h"
#import "UserManager.h"
#import "SeedUser.h"
#import "CJFTools.h"

#import "HabitGrowStatisticsView.h"
#import "NSString+CJFString.h"

@interface HabitDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *notesArr;
@property (nonatomic,strong)NSMutableArray *commentsArr;
@property (nonatomic,strong)NSMutableArray *propsArr;
@property (nonatomic,strong)NSMutableArray *noteArr;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *habitsArr;
@property (nonatomic,strong)NSMutableArray *checkArr;
@property (nonatomic,strong)NSMutableArray *check_in_timeArr;
@property (nonatomic,strong)NSMutableArray *is_check_inArr;
@property (nonatomic,strong)NSString *check_in_idStr;

// 是否下拉刷新
@property (nonatomic,assign)BOOL isRefresh;

// 存储评论数据
@property (nonatomic,strong)NSMutableString *commentStr;

@property (nonatomic,strong)UIButton *checkBtn;

// 生长统计视图
@property (nonatomic, strong) UIView *growStatisticsView;

@end

// 刷新需要的另外参数
static BOOL flag = 0;

// 上拉加载需要另外的一个数据
static NSString *nextStr = nil;
// 控制签到背景图片
static BOOL Flag = 0;

@implementation HabitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图
    [self createTableView];
    
    // 配置下拉刷新控件
    [self TableViewRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // 获取心情列表
    //    [self getNotesByTimeData];
    
    // 获取一个星期的签到情况, 并在此方法中显示当天是否已经签到
    [self getLastWeekCheck];
    
}


#pragma mark 刷新加载控件
- (void)TableViewRefresh
{
    // 弱引用,可以在里面更改self
    __weak typeof(self) weakSelf = self;
    // 默认block方法:设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        flag = 0;
        nextStr = nil;
        [weakSelf getNotesByTimeData];
    }];
    // 默认block方法:设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        flag = 1;
        [weakSelf getNotesByTimeData];
    }];
}

#pragma mark 创建tableView
- (void)createTableView
{
    self.title = self.titleStr;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:self.tableView];
    
    UINib *nib1 = [UINib nibWithNibName:@"HabitNotesByTimeCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"habit"];
    
    UINib *nib2 = [UINib nibWithNibName:@"HabitCheckInCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"checkIn"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    // 自定义工具按钮
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(0, 0, 30, 30);
    [toolBtn setImage:[UIImage imageNamed:@"tools_white_32.png"] forState:UIControlStateNormal];
    [toolBtn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem = [[UIBarButtonItem alloc]initWithCustomView:toolBtn];
    self.navigationItem.rightBarButtonItem = toolItem;
    
    
    // 创建当天的签到按钮
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
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
    
    UIView *growView = [[[NSBundle mainBundle] loadNibNamed:@"HabitGrowStatisticsView" owner:self options:nil] lastObject];
    growView.frame = CGRectMake(0, 250, SCREEN_WIDTH, 138);
    [self.tableView.tableHeaderView addSubview:growView];
    self.growStatisticsView = growView;
    
}

#pragma mark 获取心情列表数据
- (void)getNotesByTimeData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 此处post所需的参数习惯id从上一个页面通过属性传值获取,获取到的是字符串类型,相应的要转换为NSInteger类型
    NSInteger num = [self.habit_idStr integerValue];
    // 刷新状态不同时参数flag的值不一样
    NSNumber *Flag = [NSNumber numberWithBool:flag];
    
    // 设置next_id参数
    NSInteger next;
    if (flag == 1) {
        next = [nextStr integerValue];
        next--;
    }
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":Flag,
                                 @"habit_id":@(num),
                                 @"user_id": [NSString stringWithFormat:@"%@", self.user.uId],
                                 @"next_id":@(next)
                                 };
    [session POST:APIHabitNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 移除用户发表心情前的数据
        [self.noteArr removeAllObjects];
        [self.notesArr removeAllObjects];
        [self.usersArr removeAllObjects];
        [self.habitsArr removeAllObjects];
        [self.propsArr removeAllObjects];
        [self.commentsArr removeAllObjects];
        
        //        NSLog(@"%@", responseObject);
        
        if (responseObject[@"data"]) {
            
            for (NSDictionary *dic in responseObject[@"data"][@"habits"]) {
                HabitHabitsModel *habits = [[HabitHabitsModel alloc]init];
                [habits setValuesForKeysWithDictionary:dic];
                [self.habitsArr addObject:habits];
            }
            for (NSDictionary *dic1 in responseObject[@"data"][@"users"]) {
                HabitUsersModel *users = [[HabitUsersModel alloc]init];
                [users setValuesForKeysWithDictionary:dic1];
                [self.usersArr addObject:users];
            }
            for (NSDictionary *dic2 in responseObject[@"data"][@"notes"]) {
                HabitNotesModel *notes = [[HabitNotesModel alloc]init];
                [notes setValuesForKeysWithDictionary:dic2];
                [self.notesArr addObject:notes];
                
                // 评论和点赞是放在数组
                NSArray *arr = [[NSArray alloc]init];
                arr = dic2[@"coments"];
                for (NSDictionary *dic3 in arr) {
                    HabitCommentsModel *comments = [[HabitCommentsModel alloc]init];
                    [comments setValuesForKeysWithDictionary:dic3];
                    [self.commentsArr addObject:comments];
                }
                
                NSArray *arr1 = [[NSArray alloc]init];
                arr1 = dic2[@"props"];
                for (NSDictionary *dic4 in arr1) {
                    HabitPropsModel *props = [[HabitPropsModel alloc]init];
                    [props setValuesForKeysWithDictionary:dic4];
                    [self.propsArr addObject:props];
                }
                HabitNoteModel *note = [[HabitNoteModel alloc]init];
                [note setValuesForKeysWithDictionary:dic2[@"note"]];
                [self.noteArr addObject:note];
                
                // 获取note中最后一个id值,用于在上拉加载参数,一直遍历赋值获得最后一个的值
                for (HabitNoteModel *note in self.noteArr) {
                    nextStr = note.idx;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // 结束刷新
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++%@",error);
    }];
}


// 工具响应方法
- (void)toolAction:(id)sender
{
    NSLog(@"工具响应方法");
}

#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return SCREEN_WIDTH*0.5+100;
    }else if (indexPath.row == 1){
        return 180;
    }else{
        HabitNotesModel *notes = self.notesArr[indexPath.row];
        HabitNoteModel *note = notes.note;
        
        CGFloat height = [HabitNotesByTimeCell heightWithNoteStr:[note valueForKey:@"mind_note"] commentStr:self.commentStr mind_pic_small:[note valueForKey:@"mind_pic_small"]];
        return height + 300;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notesArr.count;
}

#pragma mark 返回cell 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        HabitCheckInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkIn"];
        NSInteger check_in_time = [self.check_in_times integerValue];
        cell.check_in_timeL.text = [NSString stringWithFormat:@"已坚持%ld天",(long)check_in_time];
        cell.check_in_timeL.textColor = RGB(195, 195, 195);
        cell.check_in_timeL.font = [UIFont systemFontOfSize:15];
        cell.check_in_timeL.textAlignment = NSTextAlignmentRight;
        // 把时间戳转换为星期
        if (self.checkArr.count > 0) {
            for (int i = 0; i < 7; i++) {
                for (NSDictionary *dic in self.checkArr) {
                    if ([[dic valueForKey:@"check_in_id"] integerValue] != -1 || [[dic valueForKey:@"is_check_in"] integerValue] != 0) {
                        NSInteger date = [[dic valueForKey:@"check_in_time"] integerValue];
                        NSArray *weekDay = [NSArray arrayWithObjects:[NSNull null],@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
                        NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:date];
                        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
                        NSString *weekStr = [weekDay objectAtIndex:components.weekday];
                        UIButton *btn ;
                        if ([weekStr isEqualToString:weekDay[i+1]]) {
                            btn = cell.arr[i];
                            btn.selected = YES;
                        }
                        else
                            btn.selected = NO;
                    }
                }
            }
        }
        
        return cell;
        
    }else{
        HabitNotesByTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"habit"];
        // 坚持的天数
        HabitNotesModel *notes;
        if (self.notesArr.count > 0) {
            notes = self.notesArr[indexPath.row-1];
        }
        cell.check_in_times.text = [NSString stringWithFormat:@"坚持%ld天",(long)notes.check_in_times];
        // 点语法
        HabitNoteModel *note = notes.note;
        // 时间戳转换当地时间
        NSString *str = [NSString stringWithFormat:@"%@",[note valueForKey:@"add_time"]];
        NSTimeInterval time = [str doubleValue];
        NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM:dd HH:mm"];
        NSString *add_timeStr = [formatter stringFromDate:detail];
        // 添加时间
        cell.add_time.text = add_timeStr;
        // 添加内容
        cell.mind_note.text = [note valueForKey:@"mind_note"];
        
        // 内容照片
        [cell.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
        for (HabitUsersModel *model in self.usersArr) {
            if ([note valueForKey:@"user_id"] == [model valueForKey:@"uId"]) {
                cell.users = model;
            }
        }
        // 坚持标题
        for (HabitHabitsModel *habits in self.habitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                cell.habits = habits;
                //                NSLog(@"22222%@",cell.habits);
            }
        }
        // 评论
        NSArray *commentArr1 = notes.comments;
        self.commentStr = [[NSMutableString alloc]init];
        for (HabitCommentsModel *comments in commentArr1) {
            NSString *userStr;
            NSString *comStr;
            for (HabitUsersModel *users in self.usersArr) {
                if ([comments valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                    userStr = [NSString stringWithFormat:@"%@", users.nickname];
                    comStr = [NSString stringWithFormat:@"%@", [comments valueForKey:@"comment_text_content"]];
                    [self.commentStr appendFormat:@"%@:%@\n", userStr, comStr];
                }
            }
        }
        cell.comment_text_content.text = self.commentStr;
        
        
        
        //     点赞,点赞到底在那一个cell不能由self.propsArr[indexPath.row]决定,而是由notes.props决定,每一行的点赞最多显示6个
        //    NSArray *propsArr = [[NSArray alloc]init];
        //    propsArr = notes.props;
        //    int a = (int)[note valueForKey:@"prop_count"];
        //    switch (a) {
        //            case 1:
        //            for (<#type *object#> in <#collection#>) {
        //                <#statements#>
        //            }
        //            break;
        //
        //            case 2:
        //
        //            break;
        //
        //            case 3:
        //
        //            break;
        //
        //            case 4:
        //
        //            break;
        //
        //            case 5:
        //            
        //            break;
        //
        //            case 6:
        //            
        //            break;
        //            
        //        default:
        //            break;
        //    }
        return cell;
    }
    return nil;
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
        NSLog(@"==================================%@",responseObject);
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
                
                
            });
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark 点击cell响应方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        
        // 点击cell才获取当地时间戳作为参数
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSInteger num = [self.habit_idStr integerValue];
        NSDate *datenow = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:datenow];
        NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
        NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
        NSInteger delta = [zone secondsFromGMT];
        NSInteger timeTemp = [timeSp integerValue] - delta;
        NSLog(@"%ld,%ld",(long)timeTemp,(long)num);
        NSDictionary *parameter = @{
                                    @"habit_id":@(num),
                                    @"next_check_time":@(timeTemp),
                                    @"user_id": [NSString stringWithFormat:@"%@", self.user.uId]
                                    };
        [session POST:@"http://api.idothing.com/zhongzi/v2.php/CheckIn/getLastWeekCheckIn" parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            HabitCheckInViewController *checkInVC = [[HabitCheckInViewController alloc]init];
            checkInVC.habit_idStr = self.habit_idStr;
            checkInVC.check_in_times = self.check_in_times;
            checkInVC.members = self.members;
            checkInVC.join_days = self.join_days;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:checkInVC animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}




#pragma mark 懒加载

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
- (NSMutableArray *)checkArr
{
    if (_checkArr == nil) {
        _checkArr = [NSMutableArray array];
    }
    return _checkArr;
}
- (NSMutableArray *)is_check_inArr
{
    if (_is_check_inArr == nil) {
        _is_check_inArr = [NSMutableArray array];
    }
    return _is_check_inArr;
}
- (NSMutableArray *)check_in_timeArr
{
    if (_check_in_timeArr == nil) {
        _check_in_timeArr = [NSMutableArray array];
    }
    return _check_in_timeArr;
}


@end
