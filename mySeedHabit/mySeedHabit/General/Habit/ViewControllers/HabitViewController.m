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

#import <XRCarouselView.h>

#import "Data.h"
#import "Users.h"
#import "Habits.h"
#import "Note.h"
#import "Props.h"
#import "Comments.h"
#import "Notes.h"
#import "HabitListCell.h"

#import <UIImageView+WebCache.h>

@interface HabitViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XRCarouselView *carouselView;

@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *habitsArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NSMutableArray *propsArr;
@property (nonatomic, strong) NSMutableArray *commentsArr;
@property (nonatomic, strong) NSMutableArray *notesArr;

@property (nonatomic, strong) Habits *ha;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HabitViewController

- (NSMutableArray *)usersArr {

    if (_usersArr == nil) {
        _usersArr = [[NSMutableArray alloc] init];
    }
    return _usersArr;
}
- (NSMutableArray *)habitsArr {

    if (_habitsArr == nil) {
        _habitsArr = [[NSMutableArray alloc] init];
    }
    return _habitsArr;
}
- (NSMutableArray *)noteArr {

    if (_noteArr == nil) {
        _noteArr = [[NSMutableArray alloc] init];
    }
    return _noteArr;
}
- (NSMutableArray *)propsArr {

    if (_propsArr == nil) {
        _propsArr = [[NSMutableArray alloc] init];
    }
    return _propsArr;
}
- (NSMutableArray *)commentsArr {

    if (_commentsArr == nil) {
        _commentsArr = [[NSMutableArray alloc] init];
    }
    return _commentsArr;
}
- (NSMutableArray *)notesArr {

    if (_notesArr == nil) {
        _notesArr = [[NSMutableArray alloc] init];
    }
    return _notesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self createXRCarousel];
    
    [self createScrollView];
    
    [self createTableView];
    
}

#pragma mark 创建 Tableview
- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = self.carouselView;
    
//    [self.tableView registerClass:[HabitListCell class] forCellReuseIdentifier:@"habitList"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HabitListCell" bundle:nil] forCellReuseIdentifier:@"habitList"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HabitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"habitList"];
    
    Habits *habits = self.habitsArr[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"坚持#%@#", habits.name];
    
    Notes *notes = self.notesArr[indexPath.row];
    cell.check_in_times.text = [NSString stringWithFormat:@"%ld", notes.check_in_times];
    
    // 点语法报错
    Note *note = notes.note;
    [cell.mind_pic_small sd_setImageWithURL:[NSURL URLWithString:[note valueForKey:@"mind_pic_small"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.mind_pic_small.contentMode = UIViewContentModeScaleAspectFit;
    // 时间戳转换
    NSString *timeS = [NSString stringWithFormat:@"%@", [note valueForKey:@"add_time"]];
    NSString *str = timeS;
    NSTimeInterval time = [str doubleValue] + 28800;
    NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
    //    NSLog(@"date:%@", [detail description]);
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curr = [date stringFromDate:detail];
    //    NSLog(@"%@", curr);
    cell.add_time.text = curr;
    cell.mind_note.text = [note valueForKey:@"mind_note"];
    
    Users *users = self.usersArr[indexPath.row];
    [cell.avatar_small sd_setImageWithURL:[NSURL URLWithString:users.avatar_small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    // 昵称不匹配
    for (Users *model in self.usersArr) {
        if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
            cell.nickname.text = users.nickname;
        }
//        if ([note valueForKey:@"user_id"] == dict[@"idx"]) {
//            cell.nickname.text = users.nickname;
//        }
    }
//    if ([note valueForKey:@"user_id"] == users.idx) {
//        cell.nickname.text = users.nickname;
//    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.habitsArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 600;
    
}

#pragma mark 创建 ScrollView
- (void)createScrollView {
    
    
    
}

#pragma mark 网络加载数据
- (void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":@0,
                                 @"prop_num":@10,
                                 @"user_id":@1850878
                                 };
    [session POST:APIAllHotNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"ok === %@", responseObject);
//        ULog(@"%@", responseObject);
    
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
                [self.commentsArr addObject:comments];
            }
            
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
                [self.propsArr addObject:props];
            }
            
            self.noteArr = dict[@"note"];
            [self.notesArr addObject:notes];
            
        }
        
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [self.usersArr addObject:users];
        }
        
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            [self.habitsArr addObject:habits];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark 轮播图
- (void)createXRCarousel {
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    [self.view addSubview:self.carouselView];
    
    self.carouselView.imageArray = @[@"cat.png", @"panda.png"];
    self.carouselView.time = 2;
    
}

// 退出登录
//- (IBAction)logoutClick:(UIButton *)sender {
//    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
//        LoginViewController *loginVc = [[LoginViewController alloc]init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
//            NSLog(@"登出成功");
//        }];
//    } failure:^(NSError *error) {
//        ULog(@"%@", error);
//    }];
//}

@end
