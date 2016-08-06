//
//  DiscoverViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "DiscoverViewController.h"

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
#import "DiscoverHotCell.h"

#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

#import <MJRefresh.h>

@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XRCarouselView *carouselView;

@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *habitsArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NSMutableArray *propsArr;
@property (nonatomic, strong) NSMutableArray *commentsArr;
@property (nonatomic, strong) NSMutableArray *notesArr;

@property (nonatomic, strong) Habits *ha;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableString *commentStr;

// 存储loadData参数的数据
@property (nonatomic, strong) NSMutableString *mReadStr;

@end

// 下拉加载
static BOOL isFlag = 0;

@implementation DiscoverViewController

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
    
    //    self.view.backgroundColor = RGB(245, 245, 245);
    
    self.mReadStr = [[NSMutableString alloc] init];
    
    [self loadData];
    
    [self createXRCarousel];
    
    [self createScrollView];
    
    [self createTableView];
    
    __weak typeof (self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        count++;
//        [weakSelf loadData];
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

#pragma mark 创建 Tableview
- (void)createTableView {
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = self.carouselView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverHotCell" bundle:nil] forCellReuseIdentifier:@"DiscoverHot"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoverHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverHot"];
    
    Notes *notes = self.notesArr[indexPath.row];
    cell.notes = notes;
    
    // 点语法 会导致 crash
    Note *note = notes.note;
    cell.note = notes.note;
    
    //    Habits *habits = self.habitsArr[indexPath.row];
    //    cell.habits = habits;
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            cell.habits = habits;
        }
    }
    
    // 昵称照片 ， 需要匹配到用户 ID
    for (Users *model in self.usersArr) {
        if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
            cell.users = model;
        }
    }
    
    // 点赞
    NSArray *propsArr = notes.props;
    for (int i = 0; i < 6; i++) {
        Props *props = propsArr[i];
        for (Users *model in self.usersArr) {
            if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 0) {
                [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 1) {
                [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 2) {
                [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 3) {
                [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 4) {
                [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 5) {
                [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
        }
    }
    
    // 评论
    NSArray *commentArr = notes.comments;
    self.commentStr = [[NSMutableString alloc] init];
    for (Comments *commentsM in commentArr) {
        NSString *userStr;
        NSString *comStr;
        for (Users *model in self.usersArr) {
            if ([commentsM valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                userStr = [NSString stringWithFormat:@"%@", model.nickname];
                // 点语法报错
                comStr = [NSString stringWithFormat:@"%@", [commentsM valueForKey:@"comment_text_content"]];
                [self.commentStr appendFormat:@"%@:%@\n", userStr, comStr];
            }
        }
    }
    cell.comment_text_content.text = self.commentStr;

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.notesArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notes *notes = self.notesArr[indexPath.row];
    Note *note = notes.note;
    
    CGFloat height = [DiscoverHotCell heightWithNoteStr:[note valueForKey:@"mind_note"] commentStr:self.commentStr];
    
    // 607 = 649 - 自适应
    return height + 607;
}

#pragma mark 创建 ScrollView
- (void)createScrollView {
    
}

#pragma mark 网络加载数据
- (void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSNumber *flag = [NSNumber numberWithBool:isFlag];
    NSString *readStr = self.mReadStr;
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"prop_num":@10,
                                 @"read_ids":readStr,
//                                 @"read_ids":@"18451873|18453274|18452611|18453227|18450703|18450867|18451082|18449541|18451039|18450507|18451345|18450871|18450265|18450865",
                                 @"user_id":@1850878
                                 };
    [session POST:APIAllHotNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *commentsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
//                [self.commentsArr addObject:comments];
                [commentsArr addObject:comments];
            }
            [self.commentsArr addObjectsFromArray:commentsArr];
            
            NSMutableArray *propsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
//                [self.propsArr addObject:props];
                [propsArr addObject:props];
            }
            [self.propsArr addObjectsFromArray:propsArr];
            
            NSMutableArray *noteArr = [[NSMutableArray alloc] init];
            noteArr = dict[@"note"];
            [self.noteArr addObjectsFromArray:noteArr];
            
            Note *note = dict[@"note"];
            for (NSString *s in noteArr) {
                // 拼接刷新的参数
                [self.mReadStr appendFormat:@"%@|", [note valueForKey:s]];
            }
            // 为什么不行？？？
//            NSLog(@"%@", [note valueForKey:@"idx"]);
            
            NSMutableArray *notesArr = [[NSMutableArray alloc] init];
            [notesArr addObject:notes];
            [self.notesArr addObjectsFromArray:notesArr];
        }
//        NSLog(@"%@", self.mReadStr);
        
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
//            [self.usersArr addObject:users];
            [usersArr addObject:users];
            
        }
        
        [self.usersArr addObjectsFromArray:usersArr];
        
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
//            [self.habitsArr addObject:habits];
            [habitsArr addObject:habits];
        }
        [self.habitsArr addObjectsFromArray:habitsArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 加载完第一次之后，flag == 1
            isFlag = 1;
            //
            
            // 数据加载完毕之后，结束更新
            [self.tableView.mj_footer endRefreshing];
            
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
