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

// 是否下拉刷新
@property (nonatomic,assign)BOOL isRefresh;

@end

// 刷新需要的另外参数
static BOOL flag = 0;

// 上拉加载需要另外的一个数据
static NSString *nextStr = nil;

@implementation HabitDetailsViewController

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
    [self createTableView];
    [self getData];
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
        [weakSelf getData];
    }];
    
    // 默认block方法:设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        flag = 1;
        [weakSelf getData];
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
    
    UINib *nib = [UINib nibWithNibName:@"HabitNotesByTimeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"habit"];
    
    // 自定义返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"YQNleft_32.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 自定义工具按钮
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(0, 0, 30, 30);
    [toolBtn setImage:[UIImage imageNamed:@"YQNtool_32.png"] forState:UIControlStateNormal];
    [toolBtn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem = [[UIBarButtonItem alloc]initWithCustomView:toolBtn];
    self.navigationItem.rightBarButtonItem = toolItem;
}

#pragma mark 获取网络数据
- (void)getData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 此处post所需的参数习惯id从上一个页面通过属性传值获取,获取到的是字符串类型,相应的要转换为NSNumber类型
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
        
//        NSMutableArray *habitsArray = [[NSMutableArray alloc]initWithArray:self.habitsArr];
//        NSMutableArray *usersArray = [[NSMutableArray alloc]initWithArray:self.usersArr];
//        NSMutableArray *notesArray = [[NSMutableArray alloc]initWithArray:self.notesArr];
//        NSMutableArray *commentsArray = [[NSMutableArray alloc]initWithArray:self.commentsArr];
//        NSMutableArray *propsArray = [[NSMutableArray alloc]initWithArray:self.propsArr];
//        NSMutableArray *noteArray = [[NSMutableArray alloc]initWithArray:self.noteArr];

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
            
            // 获取note中最后一个id值,用于在上拉加载参数
            for (HabitNoteModel *note in self.noteArr) {
                nextStr = note.idx;
                NSLog(@"333333333333333%@",nextStr);
            }
//            [self.habitsArr addObjectsFromArray:habitsArray];
//            [self.usersArr addObjectsFromArray:usersArray];
//            [self.notesArr addObjectsFromArray:notesArray];
//            [self.noteArr addObjectsFromArray:noteArray];
//            [self.propsArr addObjectsFromArray:propsArray];
//            [self.commentsArr addObjectsFromArray:commentsArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSLog(@"----------------------%@",self.usersArr);
            NSLog(@"//////////////////////%@",self.habitsArr);
            NSLog(@"----------------------%@",self.notesArr);
            NSLog(@"11111111111111111111111%@",self.noteArr);
            NSLog(@"----------------------%@",self.commentsArr);
            NSLog(@"----------------------%@",self.propsArr);
            NSLog(@"2222222222222222222222%@",nextStr);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 620;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HabitNotesByTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"habit"];
    // 坚持的天数
    HabitNotesModel *notes = self.notesArr[indexPath.row];
    cell.check_in_times.text = [NSString stringWithFormat:@"坚持%ld天",(long)notes.check_in_times];
    
    // 点语法
    HabitNoteModel *note = notes.note;
    // 时间戳转换
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
    NSLog(@"666666666666666666666%@",cell.mind_note.text);
    
    // 内容照片
    [cell.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
    
    for (HabitUsersModel *model in self.usersArr) {
//        NSLog(@"%@",model);
        if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
            cell.users = model;
        }
    }
    
    // 坚持标题 
    NSLog(@"11111111%@",self.habitsArr);
    for (HabitHabitsModel *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            cell.habits = habits;
            NSLog(@"22222%@",cell.habits);
        }
    }
    
    // 点赞,点赞到底在那一个cell不能由self.propsArr[indexPath.row]决定,而是由notes.props决定,每一行的点赞最多显示6个
    
    NSArray *propsArr = [[NSArray alloc]init];
    propsArr = notes.props;
    int a = (int)[note valueForKey:@"prop_count"];
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
    
//    NSArray *propsArr = [[NSArray alloc]init];
//    NSArray *prop_countArr = [NSArray array];
//    propsArr = notes.props;
//    prop_countArr = [note valueForKey:@"prop_count"];
//    NSLog(@"%@,%@",propsArr,prop_countArr);
//    if (propsArr.count != 0) {
//        for (int i = 0; i < propsArr.count; i++) {
//            HabitPropsModel *props = propsArr[i];
//            for (HabitUsersModel *users in self.usersArr) {
//                if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 0) {
//                    [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 1){
//                    [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 2){
//                    [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 3){
//                    [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 4){
//                    [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 5){
//                    [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//                }
//            }
//        }
//    }
    
    
    
    
            
    
    
    
    
    
    
            
            
            
//            {
//                [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 1){
//                [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 2){
//                [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 3){
//                [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 4){
//                [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }else if ([props valueForKey:@"user_id"] == [users valueForKey:@"idx"] && i == 5){
//                [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:[users valueForKey:@"avatar_small"]] forState:UIControlStateNormal];
//            }
//        }
//    }
//}

    
    
    // 评论
    //    HabitUsersModel *users = self.usersArr[indexPath.row];
    //    [cell.avatar_small sd_setImageWithURL:[NSURL URLWithString:users.avatar_small]];
    //    // 个人姓名
    //    cell.nickname.text = users.nickname;
    
    // 坚持标题
    //    HabitHabitsModel *habits = self.habitsArr[indexPath.row];
    //    cell.habits = habits;
    
    //    NSString *check_nameStr = [NSString stringWithFormat:@"坚持"];
    //    cell.mind_note.text = [check_nameStr stringByAppendingString:@"#%@#",[habits valueForKey:@"name"]];
    
    //    cell.check_name.text = habits.name;
    //    NSString *str = [NSString stringWithFormat:@"坚持"];
    //    self.mind_note.text = [str stringByAppendingFormat:@"#%@#",habits.name];
    
    
    //    [cell.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
    //    NSLog(@"+++++++++------%@",[note valueForKey:@"mind_pic_small"]);
    //    cell.mind_pic_small.image = [UIImage imageNamed:@"placehold.png"];
    
    //    [cell.avatar_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
    //    NSLog(@"++++++++*******%@",[note valueForKey:@"mind_pic_small"]);
    
    // 添加的照片
    //    NSURL *url = [NSURL URLWithString:[note valueForKey:@"mind_pic_small"]];
    //    [cell.mind_pic_small sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"placehold.png"]];
    //    cell.mind_pic_small.contentMode = UIViewContentModeScaleAspectFill;
    //    [cell.mind_pic_small setClipsToBounds:YES];
    //    NSLog(@"666666666666666666666%@",url);
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

@end
