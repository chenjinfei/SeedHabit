//
//  HabitDetailsViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitDetailsViewController.h"
#import "HabitViewController.h"

#import "HabitNoteModel.h"
#import "HabitNotesModel.h"
#import "HabitPropsModel.h"
#import "HabitCommentsModel.h"
#import "HabitCheckModel.h"
#import "HabitUsersModel.h"
#import "HabitNotesByTimeCell.h"

#import <UIImageView+WebCache.h>




@interface HabitDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *notesArr;
@property (nonatomic,strong)NSMutableArray *commentsArr;
@property (nonatomic,strong)NSMutableArray *propsArr;
@property (nonatomic,strong)NSMutableArray *noteArr;
@property (nonatomic,strong)NSMutableArray *usersArr;
@property (nonatomic,strong)NSMutableArray *habitsArr;

@end

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
    
    // 自定义返回按钮 详情
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"left_32.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 自定义工具按钮
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBtn.frame = CGRectMake(0, 0, 30, 30);
    [toolBtn setImage:[UIImage imageNamed:@"tool_32.png"] forState:UIControlStateNormal];
    [toolBtn addTarget:self action:@selector(toolAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem = [[UIBarButtonItem alloc]initWithCustomView:toolBtn];
    self.navigationItem.rightBarButtonItem = toolItem;
}

#pragma mark 获取网络数据
- (void)getData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":@0,
                                 @"habit_id":@376,
                                 @"user_id":@1850869
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
            NSArray *arr = [[NSArray alloc]init];
            arr = [dic2 objectForKey:@"comments"];
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
            NSArray *arr2 = [[NSArray alloc]init];
            
            for (NSDictionary *dic5 in arr2) {
                HabitNoteModel *note = [[HabitNoteModel alloc]init];
                [note setValuesForKeysWithDictionary:dic5];
                [self.noteArr addObject:note];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"----------------------%@",self.usersArr);
            NSLog(@"//////////////////////%@",self.habitsArr);
            NSLog(@"----------------------%@",self.notesArr);
            NSLog(@"----------------------%@",self.noteArr);
            NSLog(@"----------------------%@",self.commentsArr);
            NSLog(@"----------------------%@",self.propsArr);
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
    return self.usersArr.count;
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
//    [cell.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]]];
    cell.mind_pic_small.image = [UIImage imageNamed:@"placehold.png"];
    
    // 添加的照片
//    NSURL *url = [NSURL URLWithString:[note valueForKey:@"mind_pic_small"]];
//    [cell.mind_pic_small sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"placehold.png"]];
    cell.mind_pic_small.contentMode = UIViewContentModeScaleAspectFill;
    [cell.mind_pic_small setClipsToBounds:YES];
//    NSLog(@"666666666666666666666%@",url);

    return cell;
}



@end
