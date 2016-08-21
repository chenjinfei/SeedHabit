//
//  PropsListViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "PropsListViewController.h"
#import "UserCenterViewController.h"
#import "Users.h"
#import "PropsListTableViewCell.h"
#import "UIColor+CJFColor.h"
#import "SeedUser.h"
#import "UserManager.h"
#import "NSString+CJFString.h"


@interface PropsListViewController () <UITableViewDataSource, UITableViewDelegate, followDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSMutableArray *dataArr;
// 好友列表id
@property (nonatomic, strong) NSMutableArray *followArr;
// 点赞列表id
@property (nonatomic, strong) NSMutableArray *propsArr;

@property (nonatomic, strong) SeedUser *user;

@end

@implementation PropsListViewController

- (NSMutableArray *)dataArr {

    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (NSMutableArray *)followArr {

    if (_followArr == nil) {
        _followArr = [[NSMutableArray alloc] init];
    }
    return _followArr;
}
- (NSMutableArray *)propsArr {

    if (_propsArr == nil) {
        _propsArr = [[NSMutableArray alloc] init];
    }
    return _propsArr;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // 注意先后顺序
    [self loadFollowData];
    [self loadPropData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.user = [UserManager manager].currentUser;

    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    self.navigationItem.title = @"点赞列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PropsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PropsCell"];
    
}

#pragma mark UITableView -- 里面判断是否已经关注了对应的朋友
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PropsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropsCell"];
    
    cell.users = self.dataArr[indexPath.row];
    
    if ([self.followArr containsObject:self.propsArr[indexPath.row]]) {
        cell.followBtn.selected = YES;
//        NSLog(@"关注了");
    }
    else {
        cell.followBtn.selected = NO;
//        NSLog(@"没有关注");
    }
    
    cell.delegate = self;
    [cell.followBtn addTarget:self action:@selector(followBtn:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UserCenterViewController *userVC = [[UserCenterViewController alloc] init];
    
    Users *model = self.dataArr[indexPath.row];
    userVC.user = (SeedUser *)model;
    
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:userVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
    
}

#pragma mark cell 代理方法
- (void)followBtn:(id)sender {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn = sender;
 
    UIView *v = [sender superview];//获取父类view
    PropsListTableViewCell *cell = (PropsListTableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的section
    //    NSLog(@"indexPath:--------%@",indexPathAll);
    
    Users *users = self.dataArr[indexPathAll.row];
    // 未关注
    if (btn.selected == NO) {
        // 关注请求
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"followed_user_id":[users valueForKey:@"uId"],
                                     @"user_id":self.user_id
                                     //    关注
                                     //APIFollowUser
                                     //    followed_user_id=1576791&user_id=1850869
                                     };
        [session POST:APIFollowUser parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                 NSLog(@"取消 关注");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@", error);
        }];
        
    }
    else {
    // 取消关注请求
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"followed_user_id":[users valueForKey:@"uId"],
                                     @"user_id":self.user_id
                                     };
        [session POST:APICancelFollow parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                 NSLog(@"取消 关注");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@", error);
        }];
        
    }
        
    btn.selected = !btn.selected;
}

#pragma mark 加载点赞数据
- (void)loadPropData {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSDictionary *parameters = @{
                                 @"mind_note_id":self.mind_note_id,
                                 @"user_id":self.user_id
//                                 点赞列表
//                                 http://api.idothing.com/zhongzi/v2.php/MindNote/getPropsList
//                                 mind_note_id=18602076&user_id=1850869
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/MindNote/getPropsList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 0) {
    
            NSArray *arr = responseObject[@"data"][@"users"];
            for (NSDictionary *dic in arr) {
                Users *users = [[Users alloc] init];
                [users setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:users];
                [self.propsArr addObject:dic[@"id"]];
            }
    //        NSLog(@"%@", self.propsArr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
    
}
#pragma mark 加载已经关注的好友数据 -- 获取数据对比是否已经关注 (里面参数需要修正)
- (void)loadFollowData {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"num":@60,
                                 @"page":@0,
                                 // 当前用户的id
                                 @"user_id":self.user.uId
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/User/getFriendsList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 0) {
        
            NSArray *arr = responseObject[@"data"][@"users"];
            for (NSDictionary *dic in arr) {
                [self.followArr addObject:dic[@"id"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
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
