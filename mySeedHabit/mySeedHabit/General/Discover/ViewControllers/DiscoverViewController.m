//
//  DiscoverViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PropsListViewController.h"
#import "TreeInfoViewController.h"
#import "AlbumViewController.h"
#import "DiscoveTableViewCell.h"
#import "UserCenterViewController.h"
#import "UserSearchList_TBCell.h"
#import "DiscoverDetailViewController.h"

#import "UIColor+CJFColor.h"
#import "CJFTools.h"
#import "KeyboardObserved.h"
#import <XRCarouselView.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "YHJTabPageScrollView.h"
#import <MJRefresh.h>
#import "NSString+CJFString.h"
#import "CJFTools.h"

#import "Users.h"
#import "Habits.h"
#import "Note.h"
#import "Props.h"
#import "Comments.h"
#import "Notes.h"
#import "SearchHabit.h"

#import "UserManager.h"
#import "SeedUser.h"


@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>
{
    UITableView *hotTabelView;
    UITableView *keepTableView;
    UITableView *newestTableView;
    
    DiscoveTableViewCell *hotCell;
    DiscoveTableViewCell *keepCell;
    DiscoveTableViewCell *NewCell;
}

// 导航栏列表
@property (nonatomic, strong) YHJTabPageScrollView *pageScroll;
// 广告轮播
@property (nonatomic, strong) XRCarouselView *carouselView;
// 存储请求回来的广告图片
@property (nonatomic, strong) NSMutableArray *carPicArr;

// 热门
@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *habitsArr;
@property (nonatomic, strong) NSMutableArray *notesArr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSMutableString *mReadStr;

// 关注
@property (nonatomic, strong) NSMutableArray *keepUsersArr;
@property (nonatomic, strong) NSMutableArray *keepHabitsArr;
@property (nonatomic, strong) NSMutableArray *keepNotesArr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *keepNextId;

// 最新
@property (nonatomic, strong) NSMutableArray *NewUsersArr;
@property (nonatomic, strong) NSMutableArray *NewHabitsArr;
@property (nonatomic, strong) NSMutableArray *NewNotesArr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *NewNextId;


// 传递的用户信息 Push
@property (nonatomic, strong) SeedUser *user;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *mindNoteId;

// 键盘输入框
@property (nonatomic, strong) UITextView *textView;

// 搜索的tableView
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *searchDataList;

@property (nonatomic, strong) NSMutableArray *imageArr;

@end

// 上拉加载
static BOOL hotFlag = 0;
static BOOL keepFlag = 0;
static BOOL newestFlag = 0;
// 判断是否下拉刷新
static BOOL isHotRefresh = 1;
static BOOL isKeepRefresh = 1;
static BOOL isNewRefresh = 1;

@implementation DiscoverViewController

- (NSMutableArray *)imageArr {
    
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

// 热门
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
- (NSMutableArray *)notesArr {
    
    if (_notesArr == nil) {
        _notesArr = [[NSMutableArray alloc] init];
    }
    return _notesArr;
}

// 关注
- (NSMutableArray *)keepUsersArr {
    
    if (_keepUsersArr == nil) {
        _keepUsersArr = [[NSMutableArray alloc] init];
    }
    return _keepUsersArr;
}
- (NSMutableArray *)keepHabitsArr {
    
    if (_keepHabitsArr == nil) {
        _keepHabitsArr = [[NSMutableArray alloc] init];
    }
    return _keepHabitsArr;
}
- (NSMutableArray *)keepNotesArr{
    
    if (_keepNotesArr == nil) {
        _keepNotesArr = [[NSMutableArray alloc] init];
    }
    return _keepNotesArr;
}

// 最新
- (NSMutableArray *)NewUsersArr {
    
    if (_NewUsersArr == nil) {
        _NewUsersArr = [[NSMutableArray alloc] init];
    }
    return _NewUsersArr;
}
- (NSMutableArray *)NewHabitsArr {
    
    if (_NewHabitsArr == nil) {
        _NewHabitsArr = [[NSMutableArray alloc] init];
    }
    return _NewHabitsArr;
}
- (NSMutableArray *)NewNotesArr{
    
    if (_NewNotesArr == nil) {
        _NewNotesArr = [[NSMutableArray alloc] init];
    }
    return _NewNotesArr;
}

// 轮播广告
- (NSMutableArray *)carPicArr {
    
    if (_carPicArr == nil) {
        _carPicArr = [[NSMutableArray alloc] init];
    }
    return _carPicArr;
}
// 存储loadData参数的数据
- (NSMutableString *)mReadStr {
    
    if (_mReadStr == nil) {
        _mReadStr = [[NSMutableString alloc] init];
    }
    return _mReadStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserManager manager].currentUser;
    NSLog(@"%@", self.user.uId);
    
    self.view.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    // 创建tableView
    [self createTableView];
    // 头部滑动
    [self createHeadList];
    // 搜索框
    [self createSearch];
    // 上下拉刷新
    [self Refresh];
    
}

#pragma mark 即将进入这个这个控制器隐藏 导航栏隐藏 加载数据
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    //     加载数据
    [self hotLoadData];
    [self NewestLoadData];
    [self keepLoadData];
    
}
#pragma mark 即将离开这个控制器
- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark 数据刷新
- (void)Refresh {
    
    __weak typeof (self) weakSelf = self;
    
//    // hotTableView上拉下拉
    hotTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新？");
        isHotRefresh = 0;
        hotFlag = 0;
        [weakSelf hotLoadData];
    }];
//    MJRefreshGifHeader *header1 = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(hotLoadData)];
//    header1.lastUpdatedTimeLabel.hidden = YES;
//    hotTabelView.mj_header = header1;
    
    hotTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉加载");
        isHotRefresh = 1;
        hotFlag = 1;
        [weakSelf hotLoadData];
    }];


    
    
    // keepTableView上拉下拉
    keepTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉加载， 自动加载？");
        isKeepRefresh = 0;
        keepFlag = 0;
        [weakSelf keepLoadData];
    }];
//    MJRefreshGifHeader *header2 = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(keepLoadData)];
//    header2.lastUpdatedTimeLabel.hidden = YES;
//    keepTableView.mj_header = header2;
    keepTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        isKeepRefresh = 1;
        keepFlag = 1;
        [weakSelf keepLoadData];
    }];
    
    // newestTableView上拉下拉
    newestTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉加载， 自动加载？");
        isNewRefresh = 0;
        newestFlag = 0;
        [weakSelf NewestLoadData];
    }];
//    MJRefreshGifHeader *header3 = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(NewestLoadData)];
//    header3.lastUpdatedTimeLabel.hidden = YES;
//    newestTableView.mj_header = header3;
    newestTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        isNewRefresh = 1;
        newestFlag = 1;
        [weakSelf NewestLoadData];
    }];
    
}

#pragma mark 创建 ==========头部滚动列表=========
- (void)createHeadList {
    
    NSArray *pageItems = @[
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"热门" andTabView:hotTabelView],
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"关注" andTabView:keepTableView],
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"最新" andTabView:newestTableView],
                           ];
    self.pageScroll = [[YHJTabPageScrollView alloc] initWithPageItems:pageItems];
    [self.view addSubview:self.pageScroll];
    
    // 滚动列表位置
    [self.pageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark 热门轮播图
- (void)createXRCarousel {
    
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, SCREEN_HEIGHT/3+10)];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"user_id":self.user.uId
                                 // 列出轮播图和习惯
                                 // http://api.idothing.com/zhongzi/v2.php/ChoiceNote/listBannersAndHabits
                                 // user_id=1850878
                                 };
    [session POST:APIBannersAndHabits parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        
        if ([responseObject[@"status"] integerValue] == 0) {
            
            NSArray *dataArr = responseObject[@"data"][@"banners"];
            
            for (NSDictionary *dict in dataArr) {
                [self.carPicArr addObject:dict[@"banner_pic"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.carouselView.contentMode = UIViewContentModeScaleAspectFit;
                self.carouselView.imageArray = self.carPicArr;
                self.carouselView.time = 2.5;
            });
            
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@", error);
          }];
    
}

#pragma mark 创建 ==========搜索框==========
-(void)createSearch {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(SCREEN_WIDTH-35, 30, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"search_white_32.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 搜索
- (void)searchAction:(id)sender {
    
    NSLog(@"开启吧，搜索框！");
    
    self.searchList = [NSMutableArray array];
    self.searchDataList = [NSMutableArray array];
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    //    self.searchTableView.backgroundColor = [UIColor redColor];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 创建uisearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    // 设置UISearchController的显示属性，以下3属性默认为YES
    // 搜索时，背景边暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    // 搜索时，背景变模糊
    //    self.searchController.obscuresBackgroundDuringPresentation = YES;
    // 搜索时，隐藏导航栏
    //    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    self.searchController.searchBar.hidden = YES;
    self.searchController.searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    self.searchController.searchBar.barTintColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchController.searchBar.placeholder = @"输入您所感兴趣的习惯";
    
    [self.searchController.searchBar becomeFirstResponder];
    
    // 添加searchbar到self.view
    [self.view addSubview:self.searchController.searchBar];
    [self.searchController.view addSubview:self.searchTableView];
    
    
}
#pragma mark - UISearchControllerDelegate代理
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:v];
    v.backgroundColor =RGBA(240, 240, 240, 1);
    v.tag = 13;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
    searchController.searchBar.hidden=  NO;
    searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
    self.tabBarController.tabBar.hidden= NO;
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
    searchController.searchBar.hidden = YES;
    UIView *temp = [self.view viewWithTag:13];
    [temp removeFromSuperview];
    
}
- (void)presentSearchController:(UISearchController *)searchController
{
    //    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"presentSearchController");
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    
    [self searchLoadData];
    
    
}
#pragma mark 点击键盘搜索按钮的响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"search");
    
    [self searchLoadData];
    
    
}
#pragma mark 搜索框搜索加载数据
- (void)searchLoadData {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    if (![NSString isValidateEmpty:searchString]) {
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"name": searchString,
                                     @"num": @20
                                     };
        [session POST:APISearchHabit parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                
                if (self.searchList!= nil) {
                    [self.searchList removeAllObjects];
                }
                if (self.searchDataList!= nil) {
                    [self.searchDataList removeAllObjects];
                }
                for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
                    //                    SeedUser *model = [[SeedUser alloc]init];
                    //                    [model setValuesForKeysWithDictionary:dict];
                    SearchHabit *model = [[SearchHabit alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.searchList addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.searchDataList = self.searchList;
                    [self.searchTableView reloadData];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else {
        NSLog(@"搜索内容为空，请输入搜索内容！");
    }
    
}

#pragma mark 创建 ==========Tableview==========
- (void)createTableView {
    
    // 轮播
    [self createXRCarousel];
    
    hotTabelView = [self createTableViewWithidentifier:@"DiscoverHot"];
    hotTabelView.tableHeaderView = self.carouselView;
    hotTabelView.tableHeaderView.backgroundColor = RGB(245, 245, 245);
    keepTableView = [self createTableViewWithidentifier:@"DiscoverKeep"];
    newestTableView = [self createTableViewWithidentifier:@"DiscoverNewst"];
    
}
- (UITableView *)createTableViewWithidentifier:(NSString *)identifier {
    
    // 不可以直接 创一个 空的 tableView进来
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    return tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:hotTabelView]) {
        
        hotCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverHot"];
        hotTabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        hotCell.imageArr = self.imageArr;
        hotCell.usersArr = self.usersArr;
        
        Notes *notes = self.notesArr[indexPath.row];
        hotCell.notes = notes;
        Note *note = notes.note;
        hotCell.propBtn.selected = NO;
        hotCell.isDetail = NO;
        
        for (Habits *habits in self.habitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                hotCell.habits = habits;
            }
        }
        for (Users *users in self.usersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                hotCell.users = users;
            }
        }
        
        return hotCell;
    }
    
    else if ([tableView isEqual:keepTableView]) {
        
        keepCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverKeep"];
        keepTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        keepCell.imageArr = self.imageArr;
        keepCell.usersArr = self.keepUsersArr;
        Notes *notes = self.keepNotesArr[indexPath.row];
        keepCell.notes = notes;
        Note *note = notes.note;
        keepCell.propBtn.selected = NO;
        keepCell.isDetail = NO;
        
        for (Habits *habits in self.keepHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                keepCell.habits = habits;
            }
        }
        for (Users *users in self.keepUsersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                keepCell.users = users;
            }
        }
        
        return keepCell;
    }
    
    
    else if ([tableView isEqual:newestTableView]){
        
        NewCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverNewst" forIndexPath:indexPath]; 
        newestTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        NewCell.imageArr = self.imageArr;
        NewCell.usersArr = self.NewUsersArr;
        Notes *notes = self.NewNotesArr[indexPath.row];
        
        NewCell.notes = notes;
        Note *note = notes.note;
        NewCell.propBtn.selected = NO;
        NewCell.isDetail = NO;
        
        for (Habits *habits in self.NewHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                NewCell.habits = habits;
            }
        }
        for (Users *users in self.NewUsersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                NewCell.users = users;
            }
        }
        
        return NewCell;
    }
    
    // 搜索框上的tableView
    else if ([tableView isEqual:self.searchTableView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"search"];
        }
        
        if (self.searchDataList.count > 0) {
            SearchHabit *model = self.searchDataList[indexPath.row];
            cell.textLabel.text = [model valueForKey:@"name"];
            NSString *str = [NSString stringWithFormat:@"%@人在坚持", [model valueForKey:@"members"]];
            cell.detailTextLabel.text = str;
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        return cell;
    }
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:hotTabelView]) {
        return self.notesArr.count;
    }
    else if ([tableView isEqual:keepTableView]) {
        return self.keepNotesArr.count;
    }
    else if ([tableView isEqual:newestTableView]) {
        return self.NewNotesArr.count;
    }
    else if ([tableView isEqual:self.searchTableView]) {
        return self.searchDataList.count;
    }
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:hotTabelView]) {
        CGFloat height = [hotCell Height];
        return  height + 140;
    }
    else if ([tableView isEqual:keepTableView]) {
        CGFloat height = [keepCell Height];
        return  height + 140;
    }
    else if ([tableView isEqual:newestTableView]){
        CGFloat height = [NewCell Height];
        return  height + 140;
    }
    else
        return 50;
}
#pragma makr TableViewCell Row 响应方法 点击进入用户个人信息页面 || 搜索框跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableView isEqual:self.searchTableView]) {
        NSLog(@"搜索 习惯 跳转");
        self.searchController.active = NO;
        [self.navigationController pushViewController:[[AlbumViewController alloc] init] animated:YES];
    }
    
    else {

        Notes *notes;
        Note *note;
        
        DiscoverDetailViewController *detailVC = [[DiscoverDetailViewController alloc] init];
    
        if ([tableView isEqual:hotTabelView]) {
            
            notes = self.notesArr[indexPath.row];
            note = notes.note;
            for (Habits *habits in self.habitsArr) {
                if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                    detailVC.habits = habits;
                }
            }
            for (Users *users in self.usersArr) {
                if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                    detailVC.users = users;
                }
            }
            detailVC.noteId = [[note valueForKey:@"id"] integerValue];
            detailVC.imageArr = self.imageArr;
            detailVC.usersArr = self.usersArr;
            detailVC.notes = notes;
            detailVC.note = notes.note;
        }
        else if ([tableView isEqual:newestTableView]) {
            
            notes = self.NewNotesArr[indexPath.row];
            note = notes.note;
            for (Habits *habits in self.NewHabitsArr) {
                if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                    detailVC.habits = habits;
                }
            }
            for (Users *users in self.NewUsersArr) {
                if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                    detailVC.users = users;
                }
            }
            
            detailVC.imageArr = self.imageArr;
            detailVC.usersArr = self. NewUsersArr;
            detailVC.notes = notes;
            detailVC.note = notes.note;        }
        else if ([tableView isEqual:keepTableView]) {
            
            notes = self.keepNotesArr[indexPath.row];
            note = notes.note;
            for (Habits *habits in self.keepHabitsArr) {
                if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                    detailVC.habits = habits;
                }
            }
            for (Users *users in self.keepUsersArr) {
                if ([note valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                    detailVC.users = users;
                }
            }
            
            detailVC.imageArr = self.imageArr;
            detailVC.usersArr = self.keepUsersArr;
            detailVC.notes = notes;
            detailVC.note = notes.note;
        }
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
    }
    
}
#pragma mark =======网络加载数据=========
- (void)hotLoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSNumber *flag = [NSNumber numberWithBool:hotFlag];
    NSString *readStr = self.mReadStr;
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"prop_num":@10,
                                 @"read_ids":readStr,
                                 @"user_id":self.user.uId
                                 // 拼接之前用户iD
                                 // @"read_ids":@"18451873|18453274|18452611|18453227|18450703|18450867|18451082|18449541|18451039|18450507|18451345|18450871|18450265|18450865",
                                 };
    [session POST:APIAllHotNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 0) {
            __weak typeof (self) weakSelf = self;
            [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.notesArr UsersArr:weakSelf.usersArr HabitsArr:weakSelf.habitsArr isRefresh:isHotRefresh tableView:hotTabelView];
            
            //                [self keepLoadData];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@", error);
          }];
    
}

- (void)keepLoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSNumber *flag = [NSNumber numberWithBool:keepFlag];
    NSInteger next_id;
    if (keepFlag == 1) {
        next_id = [self.keepNextId integerValue];
        next_id--;
    }
    
    NSDictionary *parameters = @{
                                 // 默认十条数据
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"next_id":@(next_id),
                                 @"user_id":self.user.uId,
                                 // 刷新数据 获取 最后一个用户id - 1 = next_id
                                 //                                 http://api.idothing.com/zhongzi/v2.php/MindNote/listAllNotesByFriend
                                 //                                 detail=1&flag=0&user_id=1850869
                                 //                                 detail=1&flag=1&next_id=18503725&user_id=1850869
                                 };
    [session POST:APIAllNotesByFriend parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 0) {
            __weak typeof (self) weakSelf = self;
            [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.keepNotesArr UsersArr:weakSelf.keepUsersArr HabitsArr:weakSelf.keepHabitsArr isRefresh:isKeepRefresh tableView:keepTableView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)NewestLoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSNumber *flag = [NSNumber numberWithBool:newestFlag];
    NSInteger next_id;
    if (newestFlag == 1) {
        next_id = [self.NewNextId integerValue];
        next_id--;
    }
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"next_id":@(next_id),
                                 @"user_id":self.user.uId
                                 //                                 detail=1&flag=0&user_id=1850869
                                 //                                 detail=1&flag=1&next_id=18162615&user_id=1850878
                                 };
    
    [session POST:APIAllNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            __weak typeof (self) weakSelf = self;
            [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.NewNotesArr UsersArr:weakSelf.NewUsersArr HabitsArr:weakSelf.NewHabitsArr isRefresh:isNewRefresh tableView:newestTableView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

// 解析数据
- (void)analysisDataWithResponseObject:(id)responseObject NotesArr:(NSMutableArray *)NotesArr UsersArr:(NSMutableArray *)UsersArr HabitsArr:(NSMutableArray *)HabitsArr isRefresh:(BOOL)isRefresh tableView:(UITableView *)tableView{
    // isRefresh == 0 上拉加载
    if (isRefresh == 1) {
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            [NotesArr addObject:notes];
            
            Note *note = dict[@"note"];
            // 上拉，加载
            if ([tableView isEqual:hotTabelView]) {
                [self.mReadStr appendFormat:@"%@|", [note valueForKey:@"id"]];
            }
            else if ([tableView isEqual:newestTableView]) {
                self.NewNextId = [note valueForKey:@"id"];
            }
            else if ([tableView isEqual:keepTableView]){
                self.keepNextId = [note valueForKey:@"id"];
            }
            
        }
        
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [UsersArr addObject:users];
        }
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            [HabitsArr addObject:habits];
        }
    }
    
    else {
        
        NSMutableArray *notesArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
//            NSLog(@"%@", notes);
            if ([[[[NotesArr firstObject] valueForKey:@"note"] valueForKey:@"check_in_id"] isEqualToString:[[notes valueForKey:@"note"] valueForKey:@"check_in_id"]]) {
                break;
            }
            
            [notesArr addObject:notes];
        }
        NSArray *arr = [notesArr arrayByAddingObjectsFromArray:NotesArr];
        [NotesArr removeAllObjects];
        [NotesArr addObjectsFromArray:arr];
        
        
        NSMutableArray *userId = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in UsersArr) {
            [userId addObject:[dic valueForKey:@"uId"]]; // 获取当前所有用户的id
        }
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            // 如果没有 forin 的 id 就加入 数组
            if (![userId containsObject:[users valueForKey:@"uId"]]) {
                [usersArr addObject:users];
            }
        }
        NSArray *arr1 = [usersArr arrayByAddingObjectsFromArray:UsersArr];
        [UsersArr removeAllObjects];
        [UsersArr addObjectsFromArray:arr1];
        
        
        NSMutableArray *habitId = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in HabitsArr) {
            [habitId addObject:[dic valueForKey:@"idx"]];
        }
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            // 如果没有 forin 的 id 就加入 数组
            if (![habitId containsObject:[habits valueForKey:@"idx"]]) {
                [habitsArr addObject:habits];
            }
        }
        NSArray *arr2 = [habitsArr arrayByAddingObjectsFromArray:HabitsArr];
        [HabitsArr removeAllObjects];
        [HabitsArr addObjectsFromArray:arr2];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 数据加载完毕之后，结束更新
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];
    });
}



@end
