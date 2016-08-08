//
//  UserCenterViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/8/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserCenterViewController.h"

#import "UserManager.h"
#import "SeedUser.h"
#import "LoginViewController.h"

#import <UIImageView+WebCache.h>
#import "UIImage+CJFImage.h"
#import "UIImageView+CJFUIImageView.h"

#import "UserInfo_TBHeaderView.h"
#import "UserHaBitList_TBCell.h"

@interface UserCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *username;

@property (nonatomic, strong) UITableView *tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray  *dataArr;

@property (nonatomic, strong) UserInfo_TBHeaderView *tableHeaderView;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    
    self.username = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 150, 40)];
    [self.view addSubview:self.username];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logBtn.frame = CGRectMake(100, 150, 150, 40);
    [logBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    
    // 创建视图控件
    [self buildView];
    
    // 加载数据
    [self loadData];
    
    
    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    //    
    //    [imageView lhy_loadImageUrlStr:[UserManager manager].currentUser.avatar_small placeHolderImageName:@"placeHolder.png" radius:50];
    //    
    //    [self.view addSubview:imageView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // ==== 测试 可删除 ======
    self.username.text = [UserManager manager].currentUser.nickname;
    // ======================
    
}

// ==== 测试 可删除 ======
// 退出登录
- (void)logoutClick:(UIButton *)sender {
    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
        
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
            NSLog(@"登出成功");
        }];
        
    } failure:^(NSError *error) {
        
        ULog(@"%@", error);
        
    }];
}
// ========================


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _tableView;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

// 创建视图控件
-(void)buildView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserHaBitList_TBCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HBLTBCELL"];
    
    //    UserInfo_TBHeaderView *headerView = [[UserInfo_TBHeaderView alloc]init];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"UserInfo_TBHeaderView" owner:self options:nil][0];
    //    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    
}


// 加载数据
-(void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"user_id":[UserManager manager].currentUser.uId
                                 };
    [session POST:APIHabitList parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *habitArr = responseObject[@"data"][@"habits"];
        self.tableHeaderView.habitCountView.text = [NSString stringWithFormat:@"%ld", habitArr.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    SeedUser *user = [UserManager manager].currentUser;
    [self.tableHeaderView.avatarView lhy_loadImageUrlStr:user.avatar_small placeHolderImageName:@"placeHolder.png" radius:self.tableHeaderView.frame.size.height/2];
    
    self.tableHeaderView.followCountView.text = [NSString stringWithFormat:@"%@", user.friends_count];
    self.tableHeaderView.followerCountView.text = [NSString stringWithFormat:@"%@", user.fans_count];
    self.tableHeaderView.signatureView.text = user.signature;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserHaBitList_TBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBLTBCELL"];
    cell.textLabel.text = @"fdfdf";
    return cell;
}

@end
