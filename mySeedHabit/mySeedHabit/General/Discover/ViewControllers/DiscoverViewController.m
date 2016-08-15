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

#import "UIColor+CJFColor.h"
#import "UserManager.h"
#import "CJFTools.h"

#import <XRCarouselView.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "YHJTabPageScrollView.h"
#import <MJRefresh.h>

#import "Users.h"
#import "Habits.h"
#import "Note.h"
#import "Props.h"
#import "Comments.h"
#import "Notes.h"

#import "DiscoveTableViewCell.h"

@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate, pushDelegate>
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
@property (nonatomic, strong) XRCarouselView *carouselView;

// 热门
@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *habitsArr;
@property (nonatomic, strong) NSMutableArray *notesArr;
// 存储评论
@property (nonatomic, strong) NSMutableString *commentStr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSMutableString *mReadStr;
// 判断是否下拉刷新
@property (nonatomic, assign) BOOL isHotRefresh;

// 关注
@property (nonatomic, strong) NSMutableArray *keepUsersArr;
@property (nonatomic, strong) NSMutableArray *keepHabitsArr;
@property (nonatomic, strong) NSMutableArray *keepNotesArr;
// 存储评论
@property (nonatomic, strong) NSMutableString *keepCommentStr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *keepNextId;

// 最新
@property (nonatomic, strong) NSMutableArray *NewUsersArr;
@property (nonatomic, strong) NSMutableArray *NewHabitsArr;
@property (nonatomic, strong) NSMutableArray *NewNotesArr;
// 存储评论
@property (nonatomic, strong) NSMutableString *NewCommentStr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *NewNextId;

// 存储请求回来的广告图片
@property (nonatomic, strong) NSMutableArray *carPicArr;

@end

// 上拉加载
static BOOL hotFlag = 0;
static BOOL keepFlag = 0;
static BOOL newestFlag = 0;
// 判断是否下拉刷新
static BOOL isHotRefresh = 0;
static BOOL isKeepRefresh = 0;
static BOOL isNewRefresh = 0;

@implementation DiscoverViewController

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

- (NSMutableString *)mReadStr {

    if (_mReadStr == nil) {
        _mReadStr = [[NSMutableString alloc] init];
    }
    return _mReadStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
//    self.mReadStr = [[NSMutableString alloc] init];

    // 头部滑动
    [self createHeadList];
   
    // 上下拉刷新
    [self Refresh];
}

// 进入这个这个控制器隐藏 导航栏
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    self.view.window.backgroundColor = [UIColor whiteColor];
    
    // 加载数据
    [self hotLoadData];
    [self NewestLoadData];
    [self keepLoadData];
    
}

#pragma mark 数据刷新
- (void)Refresh {
    
    __weak typeof (self) weakSelf = self;
    
    // hotTableView上拉下拉
//    hotTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"下拉刷新？");
//        isHotRefresh = 1;
//        [weakSelf hotLoadData];
//    }];
    hotTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉加载");
        isHotRefresh = 0;
        hotFlag = 1;
        [weakSelf hotLoadData];
    }];
    
    // keepTableView上拉下拉
    keepTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉加载， 自动加载？");
        [weakSelf keepLoadData];
    }];
    keepTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        keepFlag = 1;
        [weakSelf keepLoadData];
    }];

    // newestTableView上拉下拉
    newestTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉加载， 自动加载？");
        isNewRefresh = 1;
        [weakSelf NewestLoadData];
    }];
    newestTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        isNewRefresh = 0;
        newestFlag = 1;
        [weakSelf NewestLoadData];
    }];
    
}

#pragma mark 创建 头部滚动列表
- (void)createHeadList {
    
    // 创建tableView
    [self createTableView];

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
    
    // 搜索框
    [self createSearch];
    
}

#pragma mark 创建 搜索框
-(void)createSearch {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(SCREEN_WIDTH-35, 30, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"搜索@2x.png"] forState:UIControlStateNormal];
    
}

#pragma mark 创建 Tableview
- (void)createTableView {
    
    // 轮播
    [self createXRCarousel];
    
    hotTabelView = [self createTableViewWithidentifier:@"DiscoverHot"];
    hotTabelView.tableHeaderView = self.carouselView;
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
        hotCell.usersArr = self.usersArr;
        
        Notes *notes = self.notesArr[indexPath.row];
        hotCell.notes = notes;
        Note *note = notes.note;
        
        for (Habits *habits in self.habitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
               hotCell.habits = habits;
            }
        }
        for (Users *users in self.usersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
                hotCell.users = users;
            }
        }
        
        hotCell.delegate = self;
        [hotCell.propListBtn addTarget:self action:@selector(hotPropsListPush:) forControlEvents:UIControlEventTouchUpInside];
        [hotCell.seedBtn addTarget:self action:@selector(hotTreeInfoPush:) forControlEvents:UIControlEventTouchUpInside];
        [hotCell.omitBtn addTarget:self action:@selector(hotAlbumPush:) forControlEvents:UIControlEventTouchUpInside];
        
        return hotCell;
    }
    
    else if ([tableView isEqual:keepTableView]) {
        
        keepCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverKeep"];
        
        Notes *notes = self.keepNotesArr[indexPath.row];
        keepCell.notes = notes;
        Note *note = notes.note;
        
        for (Habits *habits in self.keepHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                keepCell.habits = habits;
            }
        }
        for (Users *users in self.keepUsersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
                keepCell.users = users;
            }
        }

//        keepCell.delegate = self;
//        [keepCell.propListBtn addTarget:self action:@selector(keepPropsListPush:) forControlEvents:UIControlEventTouchUpInside];
//        [keepCell.seedBtn addTarget:self action:@selector(keepTreeInfoPush:) forControlEvents:UIControlEventTouchUpInside];
//        [keepCell.omitBtn addTarget:self action:@selector(keepAlbumPush:) forControlEvents:UIControlEventTouchUpInside];
        
        return keepCell;
    }
    
    
    else if ([tableView isEqual:newestTableView]){
        
        NewCell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverNewst"];
        
        Notes *notes = self.NewNotesArr[indexPath.row];
        NewCell.notes = notes;
        Note *note = notes.note;
        
        for (Habits *habits in self.NewHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                NewCell.habits = habits;
            }
        }
        for (Users *users in self.NewUsersArr) {
            if ([note valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
                NewCell.users = users;
            }
        }
        
//        NewCell.delegate = self;
//        [NewCell.propListBtn addTarget:self action:@selector(newPropsListPush:) forControlEvents:UIControlEventTouchUpInside];
//        [NewCell.seedBtn addTarget:self action:@selector(newTreeInfoPush:) forControlEvents:UIControlEventTouchUpInside];
//        [NewCell.omitBtn addTarget:self action:@selector(newAlbumPush:) forControlEvents:UIControlEventTouchUpInside];

        return NewCell;
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
        return 0;
}

#pragma mark cell.btn 代理事件
- (void)hotPropsListPush:(id)sender{
    
    // propsListBtn 下面还有一个view
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    UIView *v2 = [v1 superview];
    UIView *v3 = [v2 superview];
    DiscoveTableViewCell *cell = (DiscoveTableViewCell *)[v3 superview];//获取cell
    NSIndexPath *indexPath = [hotTabelView indexPathForCell:cell];//获取cell对应的section
    //    NSLog(@"indexPath:--------%@",indexPathAll);
    
    Notes *notes = self.notesArr[indexPath.row];
    Note *note = notes.note;
//     push 参数
//    self.mind_note_id = [note valueForKey:@"id"];
//    self.user_id = [note valueForKey:@"user_id"];
    
    self.hidesBottomBarWhenPushed=YES;
    PropsListViewController *propsListVC = [[PropsListViewController alloc] init];
    
    // 当前用户
    NSString *user_id = @"1850869";
    // 发表的用户
    propsListVC.user_id = user_id;
    propsListVC.mind_note_id = [note valueForKey:@"id"];
    
    [self.navigationController pushViewController:propsListVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;

}
- (void)hotTreeInfoPush:(id)sender {

    // 获取indexPath
    NSIndexPath *indexPath = [self getindePathWith:sender];
    Notes *notes = self.notesArr[indexPath.row];
    Note *note = notes.note;
    NSString *title;
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            title = habits.name;
        }
    }

    self.hidesBottomBarWhenPushed=YES;
    TreeInfoViewController *treeInfoVC = [[TreeInfoViewController alloc] init];
    
    // 发表的用户
    treeInfoVC.user_id = [note valueForKey:@"user_id"];
    // 发表的用户的习惯
    treeInfoVC.habit_id = [note valueForKey:@"habit_id"];
    // 发表的用户的坚持
    treeInfoVC.treeTitle = title;
    
    [self.navigationController pushViewController:treeInfoVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
/*
- (void)keepTreeInfoPush:(id)sender {
    
    // 获取indexPath
    NSIndexPath *indexPath = [self getindePathWith:sender];
    Notes *notes = self.keepNotesArr[indexPath.row];
    Note *note = notes.note;
    NSString *title;
    for (Habits *habits in self.keepHabitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            title = habits.name;
        }
    }
    
    self.hidesBottomBarWhenPushed=YES;
    TreeInfoViewController *treeInfoVC = [[TreeInfoViewController alloc] init];
    
    // 发表的用户
    treeInfoVC.user_id = [note valueForKey:@"user_id"];
    // 发表的用户的习惯
    treeInfoVC.habit_id = [note valueForKey:@"habit_id"];
    // 发表的用户的坚持
    treeInfoVC.treeTitle = title;
    
    [self.navigationController pushViewController:treeInfoVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (void)newTreeInfoPush:(id)sender {
    
    // 获取indexPath
    NSIndexPath *indexPath = [self getindePathWith:sender];
    Notes *notes = self.NewNotesArr[indexPath.row];
    Note *note = notes.note;
    NSString *title;
    for (Habits *habits in self.NewHabitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            title = habits.name;
        }
    }
    
    self.hidesBottomBarWhenPushed=YES;
    TreeInfoViewController *treeInfoVC = [[TreeInfoViewController alloc] init];
    
    // 发表的用户
    treeInfoVC.user_id = [note valueForKey:@"user_id"];
    // 发表的用户的习惯
    treeInfoVC.habit_id = [note valueForKey:@"habit_id"];
    // 发表的用户的坚持
    treeInfoVC.treeTitle = title;
    
    [self.navigationController pushViewController:treeInfoVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
*/
- (void)hotAlbumPush:(id)sender {
    
    NSIndexPath *indexPath = [self getindePathWith:sender];
    NSLog(@"%ld", (long)indexPath.row);
    
    Notes *notes = self.notesArr[indexPath.row];
    Note *note = notes.note;
    NSString *title;
    NSString *author;
    //     push 参数
//    self.mind_note_id = [note valueForKey:@"id"];
//    self.habit_id = [note valueForKey:@"habit_id"];
//    self.user_id = [note valueForKey:@"user_id"];
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            title = habits.name;
        }
    }
    for (Users *users in self.usersArr) {
        if ([note valueForKey:@"user_id"] == [users valueForKey:@"idx"]) {
            author = users.nickname;
        }
    }
    
    self.hidesBottomBarWhenPushed=YES;
    
    AlbumViewController *albumVC = [[AlbumViewController alloc] init];
    
    // 时间戳转时间
    NSString *timeS = [NSString stringWithFormat:@"%@", [note valueForKey:@"add_time"]];
    NSTimeInterval time = [timeS doubleValue];
    NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy.MM.dd"];
    NSString *curr = [date stringFromDate:detail];
    
    albumVC.publishText = curr;
    albumVC.authorText = [NSString stringWithFormat:@"by %@", author];
    albumVC.imageUrl = [note valueForKey:@"mind_pic_small"];
    albumVC.mind_note = [note valueForKey:@"mind_note"];
    albumVC.day = [NSString stringWithFormat:@"第%ld天", notes.check_in_times];
    albumVC.insistText = title;
    
    [self.navigationController pushViewController:albumVC animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;
    
}
#pragma mark 点击cell上面的控件，直接获取cell的indexPath
- (NSIndexPath *)getindePathWith:(id)sender {
    
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    DiscoveTableViewCell *cell = (DiscoveTableViewCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [hotTabelView indexPathForCell:cell];//获取cell对应的section
    //    NSLog(@"indexPath:--------%@",indexPathAll);
    
    return indexPathAll;
}

#pragma mark 网络加载数据 !!!

- (void)hotLoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSNumber *flag = [NSNumber numberWithBool:hotFlag];
    NSString *readStr = self.mReadStr;
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"prop_num":@10,
                                 @"read_ids":readStr,
                                 @"user_id":@1850869
                                 // 拼接之前用户iD
                                 // @"read_ids":@"18451873|18453274|18452611|18453227|18450703|18450867|18451082|18449541|18451039|18450507|18451345|18450871|18450265|18450865",
                                 };
    [session POST:APIAllHotNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
  
        [self analysisDataWithResponseObject:responseObject NotesArr:self.notesArr UsersArr:self.usersArr HabitsArr:self.habitsArr isRefresh:isHotRefresh tableView:hotTabelView];
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
                                 @"user_id":@1850869,
                                
                                 // 刷新数据 获取 最后一个用户id - 1 = next_id
//                                 http://api.idothing.com/zhongzi/v2.php/MindNote/listAllNotesByFriend
//                                 detail=1&flag=0&user_id=1850869
//                                 detail=1&flag=1&next_id=18503725&user_id=1850869
                                 };
    [session POST:APIAllNotesByFriend parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
       
        __weak typeof (self) weakSelf = self;
        [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.keepNotesArr UsersArr:weakSelf.keepUsersArr HabitsArr:weakSelf.habitsArr isRefresh:isKeepRefresh tableView:keepTableView];
        
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
                                 @"user_id":@1850869
//                                 detail=1&flag=0&user_id=1850869
//                                 detail=1&flag=1&next_id=18162615&user_id=1850878
                                 };
    
    [session POST:APIAllNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        __weak typeof (self) weakSelf = self;
        [self analysisDataWithResponseObject:responseObject NotesArr:weakSelf.NewNotesArr UsersArr:weakSelf.NewUsersArr HabitsArr:weakSelf.NewHabitsArr isRefresh:isNewRefresh tableView:newestTableView];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}


// 解析数据
- (void)analysisDataWithResponseObject:(id)responseObject NotesArr:(NSMutableArray *)NotesArr UsersArr:(NSMutableArray *)UsersArr HabitsArr:(NSMutableArray *)HabitsArr isRefresh:(BOOL)isRefresh tableView:(UITableView *)tableView{
    // isRefresh == 0 上拉加载
    if (isRefresh == 0) {
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
//    else {
//        NSMutableArray *notesArr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
//            Notes *notes = [[Notes alloc] init];
//            [notes setValuesForKeysWithDictionary:dict];
//            [notesArr addObject:notes];
//        }
//        NSArray *arr = [notesArr arrayByAddingObjectsFromArray:NotesArr];
//        [NotesArr removeAllObjects];
//        [NotesArr addObjectsFromArray:arr];
//        
//        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
//            Users *users = [[Users alloc] init];
//            [users setValuesForKeysWithDictionary:dict];
//            [usersArr addObject:users];
//        }
//        
//        NSArray *arr1 = [usersArr arrayByAddingObjectsFromArray:UsersArr];
//        [UsersArr removeAllObjects];
//        [UsersArr addObjectsFromArray:arr1];
//        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
//        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
//            Habits *habits = [[Habits alloc] init];
//            [habits setValuesForKeysWithDictionary:dict];
//            [habitsArr addObject:habits];
//        }
//        NSArray *arr2 = [habitsArr arrayByAddingObjectsFromArray:HabitsArr];
//        [HabitsArr removeAllObjects];
//        [HabitsArr addObjectsFromArray:arr2];
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 数据加载完毕之后，结束更新
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];
    });
}


#pragma mark 热门轮播图
- (void)createXRCarousel {
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"user_id":@1850869
                                 //                                 列出轮播图和习惯
                                 //                                 http://api.idothing.com/zhongzi/v2.php/ChoiceNote/listBannersAndHabits
                                 //                                 user_id=1850878
                                 };
    [session POST:APIBannersAndHabits parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        
        NSArray *dataArr = responseObject[@"data"][@"banners"];
        
        for (NSDictionary *dict in dataArr) {
            [self.carPicArr addObject:dict[@"banner_pic"]];
        }
        
#pragma mark 广告图加载是否需要返回主线程刷新？
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%@", self.carPicArr);
            self.carouselView.contentMode = UIViewContentModeScaleAspectFit;
#pragma mark 待修改
            self.carouselView.imageArray = @[self.carPicArr[0], self.carPicArr[1], self.carPicArr[2], self.carPicArr[3]];
            self.carouselView.time = 2;
        });
        
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@", error);
          }];

}

@end
