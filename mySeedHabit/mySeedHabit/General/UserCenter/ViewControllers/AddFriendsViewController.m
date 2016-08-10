//
//  AddFriendsViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AddFriendsViewController.h"

#import "UIColor+CJFColor.h"
#import "NSString+CJFString.h"
#import "KeyboardObserved.h"
#import "SeedUser.h"
#import "UserSearchList_TBCell.h"
#import "UserCenterViewController.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"

@interface AddFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchList;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
    
    [self buildView];
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

-(void)buildView {
    
    self.navigationItem.title = @"添加好友";
    
    _dataList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH , SCREEN_HEIGHT-64-49-44)];
    _tableView.backgroundColor = CLEARCOLOR;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserSearchList_TBCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"USERSEARCHCELL"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    _searchController.searchBar.delegate = self;
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
//    _searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    _searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0);
    _searchController.searchBar.barTintColor = RGBA(240, 240, 240, 1);
    _searchController.searchBar.tintColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchController.searchBar.placeholder = @"输入你要搜索的用户名";
    
    // 添加 searchbar 到 self.view
    [self.view addSubview: _searchController.searchBar];
    [_searchController.view addSubview:self.tableView];
    
    [KeyboardObserved manager];
    
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchList.count;
}


//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserSearchList_TBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USERSEARCHCELL"];
    
    cell.model = self.searchList[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.searchController.active = NO;
    
    UserCenterViewController *userVc = [[UserCenterViewController alloc]init];
    userVc.user = self.searchList[indexPath.row];
    [self.navigationController pushViewController:userVc animated:YES];
    
}

#pragma mark - UISearchControllerDelegate代理

//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
    [self updateTableViewFrame];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = NO;
    [self updateTableViewFrame];
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = YES;
    
    NSLog(@"presentSearchController");
    
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    [self updateTableViewFrame];
    
    [self loadData];
    
}


// 更新tableView的frame
-(void)updateTableViewFrame {
    CGFloat kbHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    if ([KeyboardObserved manager].keyboardIsVisible) {
        NSLog(@"open");
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-64-kbHeight);
    }else {
        NSLog(@"close");
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-49-64);
    }
    
}

// 点击搜索按钮的响应事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search");
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-49-64);
    [self loadData];
}


// 下载数据
-(void)loadData {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    if (![NSString isValidateEmpty:searchString]) {
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"nickname": searchString,
                                     @"num": @20
                                     };
        [session POST:APIUserSearch parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                
                if (self.dataList!= nil) {
                    [self.dataList removeAllObjects];
                }
                if (self.searchList!= nil) {
                    [self.searchList removeAllObjects];
                }
                for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
                    SeedUser *model = [[SeedUser alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataList addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.searchList = self.dataList;
                    [self.tableView reloadData];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else {
        NSLog(@"搜索内容为空，请输入搜索内容！");
    }
}


@end
