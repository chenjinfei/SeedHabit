//
//  DiscoverDetailViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/20.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "UIColor+CJFColor.h"
#import "DiscoveTableViewCell.h"
#import "UserCenterViewController.h"
#import "PropsListViewController.h"
#import "TreeInfoViewController.h"
#import "AlbumViewController.h"
#import "CJFTools.h"
#import "UIImageView+CJFUIImageView.h"
#import <UIImageView+WebCache.h>

#import "UserManager.h"
#import "SeedUser.h"
#import "KeyboardObserved.h"

@interface DiscoverDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DiscoveTableViewCell *cell;

@property (nonatomic, strong) SeedUser *seedUser;
@property (nonatomic, strong) NSString *mindNoteId;
// 键盘输入框
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *commentText;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL isDetail;

@end

static BOOL isCollect = 0;

@implementation DiscoverDetailViewController

- (NSMutableArray *)usersArr {

    if (_usersArr == nil) {
        _usersArr = [[NSMutableArray alloc] init];
    }
    return _usersArr;
}
- (NSMutableArray *)imageArr {

    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.seedUser = [UserManager manager].currentUser;
    NSLog(@"%@", self.seedUser.uId);
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    self.navigationItem.title = @"详情";
    
    [self createTableView];
    
    self.isDetail = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(collectAction)];
//    if (isCollect) {
//        [self.navigationItem.rightBarButtonItem setTitle:@"取消收藏"];
//    }
    
//    // 添加收藏
//#define APIAddCollection        [APICollect stringByAppendingString:@"addCollection"]
    // collect_type=1&unique_id=19163891&user_id=1878988
//    // 取消收藏
//#define APICancelCollection     [APICollect stringByAppendingString:@"cancelCollection"]
    // collect_type=1&unique_id=19163891&user_id=1878988
//    // 收藏状态   collect_type=1&unique_id=18983384&user_id=1859926
//#define APIIsCollected          [APICollect stringByAppendingString:@"isCollected"]
    
    
}

#pragma mark 即将进入
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.flag == 1) {
        [self loadData];
    }
    [self isCollected];
    
}

#pragma mark =========收藏功能==========
#pragma mark 添加收藏或者取消收藏
- (void)collectAction {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    NSLog(@"%ld, %@", (long)self.noteId, self.seedUser.uId);
    NSLog(@"%d", isCollect);
    
    NSDictionary *parameters = @{
                                 @"collect_type":@1,
                                 @"unique_id":@(self.noteId),
                                 @"user_id":self.seedUser.uId,
                                 };
    
    if (isCollect == 1) {
        
        [session POST:APICancelCollection parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue]==0) {
                NSLog(@"取消成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                isCollect = 0;
                [self.navigationItem.rightBarButtonItem setTitle:@"收藏"];
            });}
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }
    else if (isCollect == 0) {
        
        [session POST:APIAddCollection parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue]==0) {
                NSLog(@"收藏成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                isCollect = 1;
                [self.navigationItem.rightBarButtonItem setTitle:@"取消收藏"];
            });}
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    }

}
#pragma mark 收藏状态
- (void)isCollected {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // collect_type=1&unique_id=19162566&user_id=1878988
    NSDictionary *parameters = @{
                                 @"collect_type":@1,
                                 @"unique_id":@(self.noteId),
                                 @"user_id":self.seedUser.uId,
                                 };
    [session POST:APIIsCollected parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            NSLog(@"%@", responseObject);
//            NSNumber *isC = responseObject[@"data"][@"is_collected"];
            NSString *isC = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_collected"]];
            if ([isC isEqualToString:@"1"]) {
                isCollect=1;
                [self.navigationItem.rightBarButtonItem setTitle:@"取消收藏"];
            }
            else {
                [self.navigationItem.rightBarButtonItem setTitle:@"收藏"];
                isCollect = 0;
            }
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"%@", error);
    }];
    
}

#pragma mark =========创建UITableView==========
- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = RGB(245, 245, 245);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    
    self.cell.isDetail = self.isDetail;
    NSLog(@"%d", self.cell.isDetail);
   
    self.cell.imageArr = self.imageArr;
    self.cell.usersArr = self.usersArr;
    
    
    self.cell.notes = self.notes;
    self.cell.habits = self.habits;
    self.cell.users = self.users;
    
    self.cell.contentImageV.userInteractionEnabled=YES; // 开启imageView的响应方法
    
    return self.cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height= [self.cell Height];
    return height + 140;
}

#pragma mark 用户个人中心跳转详情需要重新获取数据
- (void)loadData {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 注意
    NSInteger next_id = self.noteId;
    NSLog(@"%ld", self.noteId);
    
    // 进入详情获取历史回顾 ， nextId ++ ，得到当前的习惯
//    http://api.idothing.com/zhongzi/v2.php/MindNote/listUserNotes
//    detail=1&habit_id=59&next_id=19164496&target_user_id=1562059&user_id=1878988
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"habit_id":self.habitId,
                                 @"target_user_id":self.userId,
                                 @"next_id":@(next_id),
                                 @"user_id":self.seedUser.uId,
                                 };
    [session POST:APIUserNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 0) {
       
            self.notes = [responseObject[@"data"][@"notes"] firstObject];
            Note *note = self.notes.note;
            
            for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
                if ([[note valueForKey:@"user_id"] isEqualToString:[dict valueForKey:@"id"]]) {
                    [self.users setValuesForKeysWithDictionary:dict];
                }

            }
            
            for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
                if ([[note valueForKey:@"habit_id"] isEqualToString:[dict valueForKey:@"id"]]) {
                    [self.habits setValuesForKeysWithDictionary:dict];
                }
            }
//            for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
//                Habits *habits = [[Habits alloc] init];
//                [habits setValuesForKeysWithDictionary:dict];
//                [HabitsArr addObject:habits];
//            }
            NSLog(@"%@, %@, %@", self.notes, self.users, self.habits);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.flag = 0;
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
