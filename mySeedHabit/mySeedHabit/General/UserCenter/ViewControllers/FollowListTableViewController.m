//
//  FollowListTableViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "FollowListTableViewController.h"

#import "FollowListTableViewCell.h"
#import "SeedUser.h"
#import "UserManager.h"
#import <MJRefresh.h>
#import "CJFFollowModel.h"
#import "UserCenterViewController.h"

@interface FollowListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

// 分页标识
@property (nonatomic, strong) NSNumber *page;

// 提示
@property (nonatomic, strong) UILabel *notice;

@end

@implementation FollowListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return  _dataSource;
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = self.vcTitle;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FollowListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowCell"];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = RGBA(235, 235, 235, 1);
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置footer
    self.tableView.mj_footer = footer;
    
    [self buildNotice];
    
}

// 创建提示
-(void)buildNotice {
    
    self.notice = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, SCREEN_WIDTH-30, 20)];
    [self.view addSubview:self.notice];
    self.notice.text = @"暂无任何粉丝";
    self.notice.font = [UIFont systemFontOfSize:14];
    self.notice.textColor = [UIColor darkGrayColor];
    self.notice.textAlignment = NSTextAlignmentCenter;
    
}


/**
 *  加载数据
 */
-(void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    SeedUser *currentUser = [UserManager manager].currentUser;
    
    if (self.page) {
        NSInteger newPage = [self.page integerValue] + 1;
        self.page = [NSNumber numberWithInteger:newPage];
    }else  {
        self.page = [NSNumber numberWithInteger:0];
    }
    NSDictionary *parameters = @{
                                 @"num" : @30,
                                 @"page" : self.page,
                                 @"user_id" : currentUser.uId
                                 };
    
    NSString *post = nil;
    post = [self.flag isEqualToString:@"follow"] ? APIFriendsList : APIFansList;
    
    [session POST:post parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if (responseObject[@"data"] && [responseObject[@"status"] integerValue] == 0) {
            
            for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
                
                CJFFollowModel *model = [[CJFFollowModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataSource addObject:model];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.notice removeFromSuperview];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            });
            
        }else {
            
            [self buildNotice];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hidesBottomBarWhenPushed = YES;
    UserCenterViewController *ucVc = [[UserCenterViewController alloc]init];
    ucVc.user = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:ucVc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}


@end
