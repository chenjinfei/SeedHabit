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
#import "DeserveUsersListTableViewCell.h"
#import "CJFDeserveUserModel.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <MJRefresh.h>

@interface AddFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

// 搜索结果的数组
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchList;

// 推荐用户数组
@property (nonatomic, strong) NSMutableArray *deserveDataList;
@property (nonatomic, strong) NSMutableArray *deserveIdList;
// 推荐用户的显示表格
@property (nonatomic, strong) UITableView *deserveUsersTableView;



@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
    
    [self buildView];
    
}


-(void)viewWillAppear:(BOOL)animated {
    // 加载数据
    [self loadData];
}



-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

-(UITableView *)deserveUsersTableView {
    if (!_deserveUsersTableView) {
        _deserveUsersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStyleGrouped];
    }
    return _deserveUsersTableView;
}

-(NSMutableArray *)deserveDataList {
    if (!_deserveDataList) {
        _deserveDataList = [[NSMutableArray alloc]init];
    }
    return _deserveDataList;
}

-(void)buildView {
    
    self.navigationItem.title = @"添加好友";
    
    
#pragma mark ==================  搜索 start ========================
    
    _dataList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH , SCREEN_HEIGHT-64-44)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.placeholder = @"输入你要搜索的用户名";
    
    // 添加 searchbar 到 self.view
    [self.view addSubview: _searchController.searchBar];
    [_searchController.view addSubview:self.tableView];
    
    [KeyboardObserved manager];
    
#pragma mark ==================  搜索 end ========================
    
    [self.view addSubview:self.deserveUsersTableView];
    
    self.deserveUsersTableView.delegate = self;
    self.deserveUsersTableView.dataSource = self;
    
    [self.deserveUsersTableView registerNib:[UINib nibWithNibName:@"DeserveUsersListTableViewCell" bundle:nil] forCellReuseIdentifier:@"DESERVECELL"];
    
    self.deserveUsersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置footer
    self.deserveUsersTableView.mj_footer = footer;
    
    
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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)presentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = YES;
    
    NSLog(@"presentSearchController");
    
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    [self updateTableViewFrame];
    
    [self searchData];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


// 更新tableView的frame
-(void)updateTableViewFrame {
    CGFloat kbHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    if ([KeyboardObserved manager].keyboardIsVisible) {
        NSLog(@"open");
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-64-kbHeight);
    }else {
        NSLog(@"close");
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-64);
    }
    
}

// 点击搜索按钮的响应事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search");
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-64);
    [self searchData];
}


// 搜索数据
-(void)searchData {
    
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







#pragma mark ==================  推荐关注用户 start ========================


/**
 *  加载数据
 */
-(void)loadData {
    
    AFHTTPSessionManager *session = [ AFHTTPSessionManager manager];
    
    NSMutableString *userIds = nil;
    for (int i = 0 ; i < self.deserveIdList.count; i++) {
        [userIds appendString:self.deserveIdList[i]];
        if (i != self.deserveIdList.count) {
            [userIds appendString:@"%2C"];
        }
    }
    if (userIds == nil) {
        userIds = [[NSMutableString alloc]initWithString:@""];
    }
    
    NSDictionary *parameters = @{
                                 @"note_num" : @3,
                                 @"num" : @5,
                                 @"userIds" : userIds
                                 };
    [session POST:APIListDeserveUsers parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@", responseObject);
        
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            
            CJFDeserveUserModel *model = [[CJFDeserveUserModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            
            CJFDeserveHabit *habitModel = [[CJFDeserveHabit alloc]init];
            [habitModel setValuesForKeysWithDictionary:dict[@"habit"]];
            
            NSMutableArray *mindArr = [[NSMutableArray alloc]init];
            for (NSDictionary *mDict in dict[@"habit"][@"mind_notes"]) {
                
                CJFDeserveMindNotes *mindModel = [[CJFDeserveMindNotes alloc]init];
                [mindModel setValuesForKeysWithDictionary:mDict];
                [mindArr addObject:mindModel];
                
            }
            habitModel.mind_notes = mindArr;
            
            model.habit = habitModel;
            
            [self.deserveDataList addObject:model];
            
            [self.deserveIdList addObject:[NSString stringWithFormat:@"%@", model.uId]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.deserveUsersTableView reloadData];
            [self.deserveUsersTableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


#pragma mark ==================  推荐关注用户 end ========================






#pragma mark tableView的代理方法实现

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.tableView]) {
        return self.searchList.count;
    }
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        return self.deserveDataList.count;
    }
    
    return 0;
    
}


//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView]) {
        
        UserSearchList_TBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USERSEARCHCELL"];
        
        cell.model = self.searchList[indexPath.row];
        
        return cell;
        
    }
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        
        DeserveUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DESERVECELL"];
        
        cell.model = self.deserveDataList[indexPath.row];
        
        cell.selected = NO;
        
        return cell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        return 50;
    }
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        return [DeserveUsersListTableViewCell heightWithModel:self.deserveDataList[indexPath.row]];
    }
    
    return  0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        
        self.searchController.active = NO;
        
        UserCenterViewController *userVc = [[UserCenterViewController alloc]init];
        userVc.user = self.searchList[indexPath.row];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        
        DeserveUsersListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.hidesBottomBarWhenPushed = YES;
        UserCenterViewController *ucVc = [[UserCenterViewController alloc]init];
        ucVc.user = self.deserveDataList[indexPath.row];
        [self.navigationController pushViewController:ucVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        return 30;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        return 0.001;
    }
    
    return 0.001;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.deserveUsersTableView]) {
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 30)];
        [headView addSubview:headTitle];
        headTitle.textColor = [UIColor darkGrayColor];
        headTitle.font = [UIFont systemFontOfSize:14];
        
        if (section == 0) {
            headTitle.text = @"值得关注的人";
        }
        
        return headView;
        
    }
    
    return nil;
}


@end
