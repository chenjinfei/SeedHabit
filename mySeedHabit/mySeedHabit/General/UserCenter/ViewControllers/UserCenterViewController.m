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
#import "HabitModel.h"

#import <UIImageView+WebCache.h>
#import "UIImage+CJFImage.h"
#import "UIImageView+CJFUIImageView.h"
#import <SCLAlertView.h>

#import "UserInfo_TBHeaderView.h"
#import "UserHaBitList_TBCell.h"
#import "UserSetupViewController.h"
#import "AddFriendsViewController.h"

@interface UserCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *username;

@property (nonatomic, strong) UITableView *tableView;
// 数据源
@property (nonatomic, strong) NSMutableArray  *dataArr;

@property (nonatomic, strong) UserInfo_TBHeaderView *tableHeaderView;

// 关注按钮
@property (nonatomic, strong) UIButton *followBtn;
// 弹出窗口对象
@property (nonatomic, strong) SCLAlertView *alert;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图控件
    [self buildView];
    
    // 加载数据
    [self loadData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    
}




-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

// 懒加载
-(SCLAlertView *)alert {
    _alert = [[SCLAlertView alloc]init];
    return _alert;
}

// 创建视图控件
-(void)buildView {
    
    if (!self.user) {
        
        // 创建导航右按钮
        UIButton *setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setupBtn setBackgroundImage:LOADIMAGE(@"setup_white_32_cjf", @"png") forState:UIControlStateNormal];
        setupBtn.frame = CGRectMake(0, 0, 32, 32);
        [setupBtn addTarget:self action:@selector(setupAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *setupBarBtn = [[UIBarButtonItem alloc]initWithCustomView:setupBtn];
        self.navigationItem.rightBarButtonItems = @[setupBarBtn];
        
        // 创建导航左按钮
        UIButton *searchContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchContactBtn setBackgroundImage:LOADIMAGE(@"addContact_white_32_cjf", @"png") forState:UIControlStateNormal];
        searchContactBtn.frame = CGRectMake(0, 0, 25, 25);
        [searchContactBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *searchBarBtn = [[UIBarButtonItem alloc]initWithCustomView:searchContactBtn];
        self.navigationItem.leftBarButtonItems = @[searchBarBtn];
        
    }else {
        
        // 创建加关注按钮
        // 创建导航右按钮
        self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.followBtn setTitle:@"加关注" forState:UIControlStateNormal];
        self.followBtn.frame = CGRectMake(0, 0, 70, 32);
        [self.followBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *followBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.followBtn];
        self.navigationItem.rightBarButtonItems = @[followBarBtn];
        
    }
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserHaBitList_TBCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HBLTBCELL"];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"UserInfo_TBHeaderView" owner:self options:nil][0];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    
}

// 设置按钮响应方法
-(void)setupAction: (UIButton *)sender {
    UserSetupViewController *setupVc = [[UserSetupViewController alloc]init];
    [self.navigationController pushViewController:setupVc animated:YES];
}

// 搜索联系人按钮响应方法
-(void)searchBtnAction: (UIButton *)sender {
    AddFriendsViewController *addVc = [[AddFriendsViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

// 加关注按钮响应方法
-(void)followAction: (UIButton *)sender {
    
    SeedUser *currentUser = [UserManager manager].currentUser;
    
    NSDictionary *parameters = @{
                                 @"followed_user_id": self.user.uId,
                                 @"user_id": currentUser.uId
                                 };
    
    [self addFollowWith: parameters];
    
}

/**
 *  添加关注
 *
 *  @param parameters 参数
 */
-(void)addFollowWith: (NSDictionary *)parameters {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session POST:APIFollowUser parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 已经关注
        if ([responseObject[@"status"] integerValue] == 10150) {
            
            // 取消关注
            [self cancelFollowWith: parameters];
            
        }else { // 关注成功
            NSLog(@"ok");
            [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            [self.alert showWarning:[UIApplication sharedApplication].keyWindow.rootViewController title:@"唉哟！~" subTitle:@"还不错喔，关注成功!" closeButtonTitle:@"去嗨..." duration:0.0f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


/**
 *  取消关注
 *
 *  @param parameters 参数
 */
-(void)cancelFollowWith: (NSDictionary *)parameters {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session POST:APICancelFollow parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功取消关注
        if ([responseObject[@"status"] integerValue] == 0) {
            NSLog(@"cancel");
            [self.followBtn setTitle:@"加关注" forState:UIControlStateNormal];
            [self.alert showWarning:[UIApplication sharedApplication].keyWindow.rootViewController title:@"呜呜！~" subTitle:@"真的不再关注宝宝了吗？^_^" closeButtonTitle:@"狠心离去..." duration:0.0f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


// 加载数据
-(void)loadData {
    
    SeedUser *user = [[SeedUser alloc]init];
    if (self.user) {
        user = self.user;
    }else {
        user = [UserManager manager].currentUser;
    }
    
    self.navigationItem.title = user.nickname;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if (user) {
        // 获取用户习惯列表
        NSDictionary *parameters = @{
                                     @"user_id": user.uId
                                     };
        [session POST:APIHabitList parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
                HabitModel *model = [[HabitModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
            }
            self.tableHeaderView.habitCountView.text = [NSString stringWithFormat:@"%ld", self.dataArr.count];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
        
        
        [self.tableHeaderView.avatarView lhy_loadImageUrlStr:user.avatar_small placeHolderImageName:@"placeHolder.png" radius:self.tableHeaderView.avatarView.frame.size.height/2];
        
        self.tableHeaderView.followCountView.text = [NSString stringWithFormat:@"%@", user.friends_count];
        self.tableHeaderView.followerCountView.text = [NSString stringWithFormat:@"%@", user.fans_count];
        self.tableHeaderView.signatureView.text = user.signature;
        
        if (user.gender) {
            self.tableHeaderView.genderImgView.image = [LOADIMAGE(@"man_orange_32_cjf", @"png") circleImage];
        }else {
            self.tableHeaderView.genderImgView.image = [LOADIMAGE(@"lady_orange_32_cjf", @"png") circleImage];
            
        }
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserHaBitList_TBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBLTBCELL"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
