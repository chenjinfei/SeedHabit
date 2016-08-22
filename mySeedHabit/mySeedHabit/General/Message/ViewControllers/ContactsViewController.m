//
//  ContactsViewController.m
//  我的联系人
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ContactsViewController.h"

#import "NSString+CJFString.h"
#import "UIImage+CJFImage.h"
#import "KeyboardObserved.h"
#import "UserManager.h"
#import "SeedUser.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <EMSDK.h>
#import "UIColor+CJFColor.h"

#import "MsgChatViewController.h"
#import "ContactsListTableViewCell.h"
#import "UserCenterViewController.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

// 搜索框
@property (nonatomic, strong) UISearchController *searchController;
// 数据
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *dataList;
// 表格视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchTableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

-(void)viewWillAppear:(BOOL)animated {
    // 加载数据
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.searchController.searchBar resignFirstResponder];
    
}

// 加载数据
-(void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //    num=-1&user_id=1850878
    NSDictionary *parameters = @{
                                 @"num": @-1,
                                 @"user_id": [UserManager manager].currentUser.uId
                                 };
    [session POST:APIFollowedList parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"yes = %@", responseObject[@"data"][@"users"]);
        [self.dataList removeAllObjects];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            SeedUser *modelUser = [[SeedUser alloc]init];
            [modelUser setValuesForKeysWithDictionary:dict];
            [self.dataList addObject:modelUser];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}

// 懒加载
-(NSMutableArray *)searchList {
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc]init];
    }
    return _searchList;
}

-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

// 创建控制器视图
-(void)buildView {
    self.navigationItem.title = @"我的联系人";
    
    // 创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = RGBA(225, 225, 225, 1);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CONTACTCELL"];
    
    // 搜索框
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    // 设置代理
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    _searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0);
    _searchController.searchBar.barTintColor = RGBA(240, 240, 240, 1);
    _searchController.searchBar.tintColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    
    [self.view addSubview:self.searchController.searchBar];
    
    
    // 创建tableView
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64) style:UITableViewStyleGrouped];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchTableView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.separatorColor = RGBA(225, 225, 225, 1);
    
    [self.searchTableView registerNib:[UINib nibWithNibName:@"ContactsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SEARCHCELL"];
    
}

/**
 *  输入框内容改变时的回调方法
 *
 *  @param searchController 搜索框对象
 */
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.hidesBottomBarWhenPushed = YES;
    // 监听键盘弹出
    [self keyboardManager];
    
    NSString *searchString = [self.searchController.searchBar text];
    // 输入是否为空判断
    if ([NSString isValidateEmpty:searchString]) {
        return;
    }
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    for (SeedUser *sUser in self.dataList) {
        if ([sUser.nickname rangeOfString:searchString].location != NSNotFound) {
            [self.searchList addObject:sUser];
        }
    }
    //刷新表格
    [self.searchTableView reloadData];
}

/**
 *  键盘的显示与隐藏的监听
 */
-(void)keyboardManager {
    // 键盘高度
    CGFloat keyboardHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    if ([[KeyboardObserved manager] keyboardIsVisible]) {
        NSLog(@"=open");
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-40-keyboardHeight);
        }];
    }else {
        NSLog(@"=close");
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-40+keyboardHeight);
        }];
    };
}


// 更新tableView的frame
-(void)updateTableViewFrame {
    CGFloat kbHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    if ([KeyboardObserved manager].keyboardIsVisible) {
        NSLog(@"open");
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT-24-kbHeight);
    }else {
        NSLog(@"close");
        self.tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH , SCREEN_HEIGHT-24);
    }
    
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
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = NO;
    
    NSLog(@"didDismissSearchController");
    
    [_searchTableView removeFromSuperview];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)presentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.hidden = YES;
    
    NSLog(@"presentSearchController");
    
    // 键盘高度
    CGFloat keyboardHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    NSLog(@": %f", keyboardHeight);
    
    [_searchController.view addSubview:_searchTableView];
    
    [_searchList removeAllObjects];
    [_searchTableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        _searchTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-keyboardHeight);
    }];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


/**
 *  监听键盘搜索按钮的事件
 *
 *  @param searchBar 搜索控件
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"object");
    _searchController.active = NO;
}

//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"cancel");
//}




#pragma mark tableview的代理方法实现

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    if (self.searchController.active) {
    //        return [self.searchList count];
    //    }else{
    //        return [self.dataList count];
    //    }
    
    
    if ([tableView isEqual:self.tableView]) {
        return [self.dataList count];
    }
    
    if ([tableView isEqual:self.searchTableView]) {
        return self.searchList.count;
    }
    
    return 0;
    
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView]) {
        
        ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CONTACTCELL"];
        
        //        SeedUser *user = [[SeedUser alloc]init];
        //        if (self.searchController.active) {
        //            user = self.searchList[indexPath.row];
        //        }else {
        //            user = self.dataList[indexPath.row];
        //        }
        //        cell.model = user;
        
        cell.model = self.dataList[indexPath.row];
        
        return cell;
        
    }
    
    if ([tableView isEqual:self.searchTableView]) {
        
        ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCHCELL"];
        
        cell.model = self.searchList[indexPath.row];
        
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([tableView isEqual:self.tableView]) {
        
        SeedUser *targetUser = [[SeedUser alloc]init];
        
        if (self.searchController.active) {
            NSString *searchText = [self.searchController.searchBar text];
            if ([NSString isValidateEmpty:searchText]) {
                targetUser = self.dataList[indexPath.row];
            }else {
                targetUser = self.searchList[indexPath.row];
            }
        }else {
            targetUser = self.dataList[indexPath.row];
        }
        
        self.hidesBottomBarWhenPushed = YES;
        MsgChatViewController *chatVc = [[MsgChatViewController alloc]init];
        chatVc.targetUser = targetUser;
        [self.navigationController pushViewController:chatVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
    
    if ([tableView isEqual:self.searchTableView]) {
        
        _searchController.active = NO;
        
        self.hidesBottomBarWhenPushed = YES;
        UserCenterViewController *ucVc = [[UserCenterViewController alloc]init];
        ucVc.user = self.searchList[indexPath.row];
        [self.navigationController pushViewController:ucVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}


@end
