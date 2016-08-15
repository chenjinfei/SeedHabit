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
#import "HabitNotesByTimeCell.h"
#import "HabitCheckInCell.h"
#import "HabitCheckModel.h"
#import "HabitCheckInViewController.h"

// SDWebImage可以设置为button加背景照片
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "MJRefresh.h"

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

// 是否下拉刷新
@property (nonatomic,assign)BOOL isRefresh;

// 存储评论数据
@property (nonatomic,strong)NSMutableString *commentStr;

// 当地时间的时间戳
@property (nonatomic,assign)NSInteger timeTemp;

@end

// 刷新需要的另外参数
static BOOL flag = 0;

// 上拉加载需要另外的一个数据
static NSString *nextStr = nil;

@implementation HabitDetailsViewController


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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self getWeelCheckInData];
    [self getNotesByTimeData];
    [self TableViewRefresh];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:self.tableView];
    
    UINib *nib1 = [UINib nibWithNibName:@"HabitNotesByTimeCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"habit"];
    UINib *nib2 = [UINib nibWithNibName:@"HabitCheckInCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"check"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    // 自定义工具按钮
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(0, 0, 30, 30);
    [toolBtn setImage:[UIImage imageNamed:@"tool_32.png"] forState:UIControlStateNormal];
    [toolBtn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem = [[UIBarButtonItem alloc]initWithCustomView:toolBtn];
    self.navigationItem.rightBarButtonItem = toolItem;
}

#pragma mark 获取签到列表数据
- (void)getWeelCheckInData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSInteger num = [self.habit_idStr integerValue];
    // 把当地时间转换为时间戳,作为参数
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    self.timeTemp = [timeSp integerValue];
    NSLog(@"%ld %ld",(long)self.timeTemp,(long)num);
    NSDictionary *parameters = @{
                                 @"habit_id":@(num),
                                 @"user_id":@1850869,
                                 @"next_check_in_time":@(self.timeTemp)
                                 };
    [session POST:APILastWeekCheckIn parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"check_ins"]) {
            HabitCheckModel *check = [[HabitCheckModel alloc]init];
            [check setValuesForKeysWithDictionary:dic];
            [self.checkArr addObject:check];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



#pragma mark 获取心情列表数据
- (void)getNotesByTimeData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 此处post所需的参数习惯id从上一个页面通过属性传值获取,获取到的是字符串类型,相应的要转换为NSInteger类型
    NSInteger num = [self.habit_idStr integerValue];
    NSLog(@"%ld", num);
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
                                 @"user_id":@1850869,
                                 @"next_id":@(next)
                                 };
    [session POST:APIHabitNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++%@",error);
    }];
}


- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toolAction:(id)sender
{
    
}

#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 150;
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
    if (indexPath.row == 0 || indexPath.row == 1) {
//        HabitCheckInCell *checkCell = [tableView dequeueReusableCellWithIdentifier:@"check"];
//        HabitCheckModel *check = [[HabitCheckModel alloc]init];
//        
//        NSInteger num;
//        for (NSDictionary *dic in self.checkArr) {
//            if ([dic[@"check_in_time"] isKindOfClass:[NSString class]]) {
//                num = [dic[@"check_in_time"] integerValue];
//            }else{
//                num = (NSInteger)dic[@"check_in_time"];
//            }
//            NSNumber *number = [NSNumber numberWithInteger:num];
//            [self.check_in_timeArr addObject:number];
//        }
//        [self.check_in_timeArr.lastObject integerValue];
//        NSArray *weekday = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
//        NSDate *date = [NSDate date];
//        NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:date];
//        
//    
//        // 坚持天数
//        NSInteger check_in_time = [self.check_in_times integerValue];
//        NSString *str = [NSString stringWithFormat:@"已坚持%ld天",(long)check_in_time];
//        checkCell.check_in_timeL.text = str;
//
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
        cell.textLabel.text = @"这怎么搞";
        return cell;
        
    } else {
        HabitNotesByTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"habit"];
        // 坚持的天数
        HabitNotesModel *notes = self.notesArr[indexPath.row-2];
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
            if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                cell.users = model;
            }
        }
        // 坚持标题
        for (HabitHabitsModel *habits in self.habitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                cell.habits = habits;
                NSLog(@"22222%@",cell.habits);
            }
        }
        // 评论
        NSArray *commentArr1 = notes.comments;
        self.commentStr = [[NSMutableString alloc]init];
        for (HabitCommentsModel *comments in commentArr1) {
            NSString *userStr;
            NSString *comStr;
            for (HabitUsersModel *users in self.usersArr) {
                if ([comments valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
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

#pragma mark 点击cell响应方法 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        HabitCheckInViewController *checkInVC = [[HabitCheckInViewController alloc]init];
        [self.navigationController pushViewController:checkInVC animated:YES];
    }
}


@end
