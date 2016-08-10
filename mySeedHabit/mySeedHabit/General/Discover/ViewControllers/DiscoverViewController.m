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

#import "UserManager.h"
#import "LoginViewController.h"

#import <XRCarouselView.h>

#import "Data.h"
#import "Users.h"
#import "Habits.h"
#import "Note.h"
#import "Props.h"
#import "Comments.h"
#import "Notes.h"
#import "DiscoverHotCell.h"

#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "YHJTabPageScrollView.h"

#import <MJRefresh.h>

@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate, pushDelegate>
{

    UITableView *hotTabelView;
    UITableView *keepTableView;
    UITableView *newestTableView;
    
}

// 导航栏列表
@property (nonatomic, strong) YHJTabPageScrollView *pageScroll;
@property (nonatomic, strong) XRCarouselView *carouselView;

// 热门
@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, strong) NSMutableArray *habitsArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NSMutableArray *propsArr;
@property (nonatomic, strong) NSMutableArray *commentsArr;
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
@property (nonatomic, strong) NSMutableArray *keepNoteArr;
@property (nonatomic, strong) NSMutableArray *keepPropsArr;
@property (nonatomic, strong) NSMutableArray *keepCommentsArr;
@property (nonatomic, strong) NSMutableArray *keepNotesArr;
// 存储评论
@property (nonatomic, strong) NSMutableString *keepCommentStr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *keepNextId;

// 最新
@property (nonatomic, strong) NSMutableArray *NewUsersArr;
@property (nonatomic, strong) NSMutableArray *NewHabitsArr;
@property (nonatomic, strong) NSMutableArray *NewNoteArr;
@property (nonatomic, strong) NSMutableArray *NewPropsArr;
@property (nonatomic, strong) NSMutableArray *NewCommentsArr;
@property (nonatomic, strong) NSMutableArray *NewNotesArr;
// 存储评论
@property (nonatomic, strong) NSMutableString *NewCommentStr;
// 存储loadData参数的数据
@property (nonatomic, strong) NSString *NewNextId;

// 传递push的参数
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *mind_note_id;
@property (nonatomic, strong) NSString *habit_id;
@property (nonatomic, strong) NSString *treeTitle;


@end

// 上拉加载
static BOOL hotFlag = 0;
static BOOL keepFlag = 0;
static BOOL newestFlag = 0;
// 判断是否下拉刷新
static BOOL isHotRefresh = 0;
//static BOOL isKeepRefresh = 0;
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
- (NSMutableArray *)noteArr {
    
    if (_noteArr == nil) {
        _noteArr = [[NSMutableArray alloc] init];
    }
    return _noteArr;
}
- (NSMutableArray *)propsArr {
    
    if (_propsArr == nil) {
        _propsArr = [[NSMutableArray alloc] init];
    }
    return _propsArr;
}
- (NSMutableArray *)commentsArr {
    
    if (_commentsArr == nil) {
        _commentsArr = [[NSMutableArray alloc] init];
    }
    return _commentsArr;
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
- (NSMutableArray *)keepNoteArr {
    
    if (_keepNoteArr == nil) {
        _keepNoteArr = [[NSMutableArray alloc] init];
    }
    return _keepNoteArr;
}
- (NSMutableArray *)keepPropsArr {
    
    if (_keepPropsArr == nil) {
        _keepPropsArr = [[NSMutableArray alloc] init];
    }
    return _propsArr;
}
- (NSMutableArray *)keepCommentsArr {
    
    if (_keepCommentsArr == nil) {
        _keepCommentsArr = [[NSMutableArray alloc] init];
    }
    return _keepCommentsArr;
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
- (NSMutableArray *)NewNoteArr {
    
    if (_NewNoteArr == nil) {
        _NewNoteArr = [[NSMutableArray alloc] init];
    }
    return _NewNoteArr;
}
- (NSMutableArray *)NewPropsArr {
    
    if (_NewPropsArr == nil) {
        _NewPropsArr = [[NSMutableArray alloc] init];
    }
    return _NewPropsArr;
}
- (NSMutableArray *)NewCommentsArr {
    
    if (_NewCommentsArr == nil) {
        _NewCommentsArr = [[NSMutableArray alloc] init];
    }
    return _NewCommentsArr;
}
- (NSMutableArray *)NewNotesArr{
    
    if (_NewNotesArr == nil) {
        _NewNotesArr = [[NSMutableArray alloc] init];
    }
    return _NewNotesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:168/255.0 blue:130/255.0 alpha:1];
    
    self.mReadStr = [[NSMutableString alloc] init];

    // 头部滑动
    [self createHeadList];
    
    // 刷新
    [self Refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    
      self.navigationController.navigationBarHidden = YES;
    
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
//        NSLog(@"下拉加载， 自动加载？");
//        isHotRefresh = 1;
//        [weakSelf hotLoadData];
//    }];
    hotTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        isHotRefresh = 0;
        hotFlag = 1;
        [weakSelf hotLoadData];
    }];
    
//    // keepTableView上拉下拉
//    keepTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"下拉加载， 自动加载？");
//        [weakSelf keepLoadData];
//    }];
    keepTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载完第一次之后，flag == 1
        NSLog(@"上拉刷新");
        keepFlag = 1;
        [weakSelf keepLoadData];
    }];
//
    // newestTableView上拉下拉
//    newestTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"下拉加载， 自动加载？");
//        isNewRefresh = 1;
//        [weakSelf NewLoadData];
//    }];
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

    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:150/255.0 alpha:1];

    NSArray *pageItems = @[
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"热门" andTabView:hotTabelView],
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"关注" andTabView:keepTableView],
                           [[YHJTabPageScrollViewPageItem alloc] initWithTabName:@"最新" andTabView:newestTableView],
                           ];
    self.pageScroll = [[YHJTabPageScrollView alloc] initWithPageItems:pageItems];
    
    [self.view addSubview:self.pageScroll];
    
    [self.pageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
// cell.btn 代理事件
- (void)propsListPush:(id)sender {
    
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    DiscoverHotCell *cell = (DiscoverHotCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [hotTabelView indexPathForCell:cell];//获取cell对应的section
//    NSLog(@"indexPath:--------%@",indexPathAll);
    
    Notes *notes = self.notesArr[indexPathAll.row];
    Note *note = notes.note;
    // push 参数
    self.mind_note_id = [note valueForKey:@"id"];
    self.user_id = [note valueForKey:@"user_id"];

    PropsListViewController *propsListVC = [[PropsListViewController alloc] init];
    
    // 当前用户
    self.user_id = @"1850869";
    // 发表的用户
    propsListVC.user_id = self.user_id;
    propsListVC.mind_note_id = self.mind_note_id;
    
    [self.navigationController pushViewController:propsListVC animated:YES];
    
}
- (void)treeInfoPush:(id)sender {
    
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    DiscoverHotCell *cell = (DiscoverHotCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [hotTabelView indexPathForCell:cell];//获取cell对应的section
    //    NSLog(@"indexPath:--------%@",indexPathAll);
    
    Notes *notes = self.notesArr[indexPathAll.row];
    Note *note = notes.note;
    // push 参数
    self.mind_note_id = [note valueForKey:@"id"];
    self.habit_id = [note valueForKey:@"habit_id"];
    self.user_id = [note valueForKey:@"user_id"];
    for (Habits *habits in self.habitsArr) {
        if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
            self.treeTitle = habits.name;
        }
    }
    
    TreeInfoViewController *treeInfoVC = [[TreeInfoViewController alloc] init];
    
    // 发表的用户
    treeInfoVC.user_id = self.user_id;
    // 发表的用户的习惯
    treeInfoVC.habit_id = self.habit_id;
    // 发表的用户的坚持
    treeInfoVC.treeTitle = self.treeTitle;
    
    [self.navigationController pushViewController:treeInfoVC animated:YES];
}

- (void)createTableView {
    
    // 轮播
    [self createXRCarousel];
    
    hotTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//    [self.view addSubview:hotTabelView];
    hotTabelView.delegate =self;
    hotTabelView.dataSource = self;
    hotTabelView.tableHeaderView = self.carouselView;
    hotTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [hotTabelView registerNib:[UINib nibWithNibName:@"DiscoverHotCell" bundle:nil] forCellReuseIdentifier:@"DiscoverHot"];
    
    keepTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //    [self.view addSubview:hotTabelView];
    keepTableView.delegate =self;
    keepTableView.dataSource = self;
//    keepTableView.tableHeaderView = self.carouselView;
    keepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [keepTableView registerNib:[UINib nibWithNibName:@"DiscoverHotCell" bundle:nil] forCellReuseIdentifier:@"DiscoverKeep"];
//    [keepTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DiscoverKeep"];
    
    newestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    //    [self.view addSubview:hotTabelView];
    newestTableView.delegate =self;
    newestTableView.dataSource = self;
//    newestTableView.tableHeaderView = self.carouselView;
    newestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [newestTableView registerNib:[UINib nibWithNibName:@"DiscoverHotCell" bundle:nil] forCellReuseIdentifier:@"DiscoverNewst"];
//    [newestTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DiscoverNewst"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:hotTabelView]) {
        DiscoverHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverHot"];
        
        Notes *notes = self.notesArr[indexPath.row];
        cell.notes = notes;
//        NSLog(@"hot=%@",self.notesArr[indexPath.row]);

        // 点语法 会导致 crash
        Note *note = notes.note;
        cell.note = notes.note;
        
        //    Habits *habits = self.habitsArr[indexPath.row];
        //    cell.habits = habits;
        for (Habits *habits in self.habitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                cell.habits = habits;
            }
        }
        
        // 昵称照片 ， 需要匹配到用户 ID
        for (Users *model in self.usersArr) {
            if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                cell.users = model;
            }
        }
        
        // 点赞
        NSArray *propsArr = notes.props;
        for (int i = 0; i < 6; i++) {
            Props *props = propsArr[i];
            for (Users *model in self.usersArr) {
                if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 0) {
                    [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 1) {
                    [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 2) {
                    [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 3) {
                    [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 4) {
                    [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 5) {
                    [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }
            }
        }
        
        // 评论
        NSArray *commentArr = notes.comments;
        self.commentStr = [[NSMutableString alloc] init];
        for (Comments *commentsM in commentArr) {
            NSString *userStr;
            NSString *comStr;
            for (Users *model in self.usersArr) {
                if ([commentsM valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                    userStr = [NSString stringWithFormat:@"%@", model.nickname];
                    // 点语法报错
                    comStr = [NSString stringWithFormat:@"%@", [commentsM valueForKey:@"comment_text_content"]];
                    [self.commentStr appendFormat:@"%@:%@\n", userStr, comStr];
                }
            }
        }
        cell.comment_text_content.text = self.commentStr;
        
        
        cell.delegate = self;
        [cell.propListBtn addTarget:self action:@selector(propsListPush:) forControlEvents:UIControlEventTouchUpInside];
        [cell.treeInfo addTarget:self action:@selector(treeInfoPush:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    else if ([tableView isEqual:keepTableView]) {
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverKeep"];
//        cell.textLabel.text = @"keep";
        
        DiscoverHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverKeep"];
        
        Notes *notes = self.keepNotesArr[indexPath.row];
        cell.notes = notes;
//        NSLog(@"keep=%@",self.keepNotesArr[indexPath.row]);
        // 点语法 会导致 crash
        Note *note = notes.note;
        cell.note = notes.note;
        
        //    Habits *habits = self.habitsArr[indexPath.row];
        //    cell.habits = habits;
        for (Habits *habits in self.keepHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                cell.habits = habits;
            }
        }
        
        // 昵称照片 ， 需要匹配到用户 ID
        for (Users *model in self.keepUsersArr) {
            if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                cell.users = model;
            }
        }
        
        // 点赞
//        NSArray *propsArr = notes.props;
//        for (int i = 0; i < 6; i++) {
//            Props *props = propsArr[i];
//            for (Users *model in self.keepUsersArr) {
//                if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 0) {
//                    [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 1) {
//                    [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 2) {
//                    [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 3) {
//                    [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 4) {
//                    [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 5) {
//                    [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }
//            }
//        }
        
        // 评论
        NSArray *commentArr = notes.comments;
        self.keepCommentStr = [[NSMutableString alloc] init];
        for (Comments *commentsM in commentArr) {
            NSString *userStr;
            NSString *comStr;
            for (Users *model in self.keepUsersArr) {
                if ([commentsM valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                    userStr = [NSString stringWithFormat:@"%@", model.nickname];
                    // 点语法报错
                    comStr = [NSString stringWithFormat:@"%@", [commentsM valueForKey:@"comment_text_content"]];
                    [self.keepCommentStr appendFormat:@"%@:%@\n", userStr, comStr];
                }
            }
        }
        cell.comment_text_content.text = self.keepCommentStr;
        
        return cell;
        
    }
    
    
    else if ([tableView isEqual:newestTableView]){
    
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverNewst"];
//        cell.textLabel.text = @"newst";
//        return cell;
        
        DiscoverHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverNewst"];
        
        Notes *notes = self.NewNotesArr[indexPath.row];
        cell.notes = notes;
//        NSLog(@"news=%@",self.NewNotesArr[indexPath.row]);

        // 点语法 会导致 crash
        Note *note = notes.note;
        cell.note = notes.note;
        
        //    Habits *habits = self.habitsArr[indexPath.row];
        //    cell.habits = habits;
        for (Habits *habits in self.NewHabitsArr) {
            if ([note valueForKey:@"habit_id"] == [habits valueForKey:@"idx"]) {
                cell.habits = habits;
            }
        }
        
        // 昵称照片 ， 需要匹配到用户 ID
        for (Users *model in self.NewUsersArr) {
            if ([note valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                cell.users = model;
            }
        }
        
        // 点赞
//        NSArray *propsArr = notes.props;
//        for (int i = 0; i < 6; i++) {
//            Props *props = propsArr[i];
//            for (Users *model in self.NewUsersArr) {
//                if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 0) {
//                    [cell.propUser1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 1) {
//                    [cell.propUser2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 2) {
//                    [cell.propUser3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 3) {
//                    [cell.propUser4 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 4) {
//                    [cell.propUser5 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }else if ([props valueForKey:@"user_id"] == [model valueForKey:@"idx"] && i == 5) {
//                    [cell.propUser6 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar_small] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//                }
//            }
//        }
        
        // 评论
        NSArray *commentArr = notes.comments;
        self.NewCommentStr = [[NSMutableString alloc] init];
        for (Comments *commentsM in commentArr) {
            NSString *userStr;
            NSString *comStr;
            for (Users *model in self.NewUsersArr) {
                if ([commentsM valueForKey:@"user_id"] == [model valueForKey:@"idx"]) {
                    userStr = [NSString stringWithFormat:@"%@", model.nickname];
                    // 点语法报错
                    comStr = [NSString stringWithFormat:@"%@", [commentsM valueForKey:@"comment_text_content"]];
                    [self.NewCommentStr appendFormat:@"%@:%@\n", userStr, comStr];
                }
            }
        }
        cell.comment_text_content.text = self.NewCommentStr;
        
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
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:hotTabelView]) {
        
        Notes *notes = self.notesArr[indexPath.row];
        Note *note = notes.note;
        
        CGFloat height = [DiscoverHotCell heightWithNoteStr:[note valueForKey:@"mind_note"] commentStr:self.commentStr mind_pic_small:[note valueForKey:@"mind_pic_small"]];

        return height + 257;
        
    }
    else if ([tableView isEqual:keepTableView]) {
        Notes *notes = self.keepNotesArr[indexPath.row];
        Note *note = notes.note;
        
        CGFloat height = [DiscoverHotCell heightWithNoteStr:[note valueForKey:@"mind_note"] commentStr:self.keepCommentStr mind_pic_small:[note valueForKey:@"mind_pic_small"]];

        return height + 257;
    }
    else if ([tableView isEqual:newestTableView]){
        Notes *notes = self.NewNotesArr[indexPath.row];
        Note *note = notes.note;
        
        CGFloat height = [DiscoverHotCell heightWithNoteStr:[note valueForKey:@"mind_note"] commentStr:self.NewCommentStr mind_pic_small:[note valueForKey:@"mind_pic_small"]];
        
        return height + 257;
    }
    return 0;
}

#pragma mark 网络加载数据

// 解析数据
/*
- (void)analysisDataWithResponseObject:(id)responseObject CommentsArr:(NSMutableArray *)CommentsArr PropsArr:(NSMutableArray *)PropsArr NoteArr:(NSMutableArray *)NoteArr NotesArr:(NSMutableArray *)NotesArr UsersArr:(NSMutableArray *)UsersArr HabitsArr:(NSMutableArray *)HabitsArr {
    
        NSMutableArray *notesArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *commentsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
                [commentsArr addObject:comments];
            }
            [CommentsArr addObjectsFromArray:commentsArr];
            
            NSMutableArray *propsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
                [propsArr addObject:props];
            }
            [PropsArr addObjectsFromArray:propsArr];
            
            NSMutableArray *noteArr = [[NSMutableArray alloc] init];
            noteArr = dict[@"note"];
            [NoteArr addObjectsFromArray:noteArr];
            
            if (isHotRefresh == 0) {
                Note *note = dict[@"note"];
                for (NSString *s in noteArr) {
                    // 拼接刷新的参数
                    [self.mReadStr appendFormat:@"%@|", [note valueForKey:s]];
                }
            }
            [notesArr addObject:notes];
        }
        [NotesArr addObjectsFromArray:notesArr];
    
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [usersArr addObject:users];
        }
        [UsersArr addObjectsFromArray:usersArr];
        
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            [habitsArr addObject:habits];
        }
        [HabitsArr addObjectsFromArray:habitsArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 数据加载完毕之后，结束更新
            [hotTabelView.mj_footer endRefreshing];
            [hotTabelView.mj_header endRefreshing];
            [hotTabelView reloadData];
        });
}
*/
- (void)hotLoadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSNumber *flag = [NSNumber numberWithBool:hotFlag];
    NSString *readStr = self.mReadStr;
    
    NSDictionary *parameters = @{
                                 @"detail":@1,
                                 @"flag":flag,
                                 @"prop_num":@10,
                                 @"read_ids":readStr,
                                 // 拼接之前用户iD
//                                 @"read_ids":@"18451873|18453274|18452611|18453227|18450703|18450867|18451082|18449541|18451039|18450507|18451345|18450871|18450265|18450865",
                                 @"user_id":@1850869
                                 };
    [session POST:APIAllHotNotes parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
    
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *commentsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
//                [self.commentsArr addObject:comments];
                [commentsArr addObject:comments];
            }
            // 判断上拉或者下拉
            if (isHotRefresh == 1) {
                [commentsArr addObjectsFromArray:self.commentsArr];
                self.commentsArr = commentsArr;
            }
            else
                [self.commentsArr addObjectsFromArray:commentsArr];
            
            NSMutableArray *propsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
//                [self.propsArr addObject:props];
                [propsArr addObject:props];
            }
            if (isHotRefresh == 1) {
                [propsArr addObjectsFromArray:self.propsArr];
                self.propsArr = propsArr;
            }
            else
                [self.propsArr addObjectsFromArray:propsArr];
            
            NSMutableArray *noteArr = [[NSMutableArray alloc] init];
            noteArr = dict[@"note"];
            if (isHotRefresh == 1) {
                [noteArr addObjectsFromArray:self.noteArr];
                self.noteArr = noteArr;
            }
            else
                [self.noteArr addObjectsFromArray:noteArr];
            
            
            if (isHotRefresh == 0) {
                Note *note = dict[@"note"];
                for (NSString *s in noteArr) {
                    // 拼接刷新的参数
                    [self.mReadStr appendFormat:@"%@|", [note valueForKey:s]];
                }
                // 为什么不行？？？
                //            NSLog(@"%@", [note valueForKey:@"idx"]);
            }
            
            NSMutableArray *notesArr = [[NSMutableArray alloc] init];
            [notesArr addObject:notes];
            if (isHotRefresh == 1) {
                [notesArr addObjectsFromArray:self.notesArr];
                self.notesArr = notesArr;
            }
            else
                [self.notesArr addObjectsFromArray:notesArr];
        }
//        NSLog(@"%@", self.mReadStr);
        
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
//            [self.usersArr addObject:users];
            [usersArr addObject:users];
        }
        if (isHotRefresh == 1) {
            [usersArr addObjectsFromArray:self.usersArr];
            self.usersArr = usersArr;
        }
        else
            [self.usersArr addObjectsFromArray:usersArr];
        
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
//            [self.habitsArr addObject:habits];
            [habitsArr addObject:habits];
        }
        if (isHotRefresh == 1) {
            [habitsArr addObjectsFromArray:self.habitsArr];
            self.habitsArr = habitsArr;
        }
        else
            [self.habitsArr addObjectsFromArray:habitsArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 数据加载完毕之后，结束更新
            [hotTabelView.mj_footer endRefreshing];
            [hotTabelView.mj_header endRefreshing];
            [hotTabelView reloadData];
        });
        
//        [self analysisDataWithResponseObject:responseObject CommentsArr:self.commentsArr PropsArr:self.propsArr NoteArr:self.noteArr NotesArr:self.notesArr UsersArr:self.usersArr HabitsArr:self.habitsArr];
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
//                                 @"flag":@0,
//                                 @"next_id":@18503725,
                                 @"user_id":@1850869,
                                
                                 // 刷新数据 获取 最后一个用户id - 1 = next_id
//                                 http://api.idothing.com/zhongzi/v2.php/MindNote/listAllNotesByFriend
//                                 detail=1&flag=0&user_id=1850869
//                                 detail=1&flag=1&next_id=18503725&user_id=1850869
//                                 detail=1&flag=1&next_id=18421893&user_id=1850869
//                                 detail=1&flag=1&next_id=18372514&user_id=1850869
                                 };
    [session POST:APIAllNotesByFriend parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"ok === %@", responseObject);
        //        ULog(@"%@", responseObject);
        
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *commentsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
                [commentsArr addObject:comments];
            }
            [self.keepCommentsArr addObjectsFromArray:commentsArr];
            
            NSMutableArray *propsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
                [propsArr addObject:props];
            }
            [self.keepPropsArr addObjectsFromArray:propsArr];
            
            NSMutableArray *noteArr = [[NSMutableArray alloc] init];
            noteArr = dict[@"note"];
            [self.keepNoteArr addObjectsFromArray:noteArr];
            
            // 存储刷新ID
            Note *note = dict[@"note"];
            self.keepNextId =[note valueForKey:@"id"];
//            NSLog(@"%@", self.keepNextId);
            
            NSMutableArray *notesArr = [[NSMutableArray alloc] init];
            [notesArr addObject:notes];
            [self.keepNotesArr addObjectsFromArray:notesArr];
        }
        
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [usersArr addObject:users];
        }
        [self.keepUsersArr addObjectsFromArray:usersArr];
        
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            //            [self.habitsArr addObject:habits];
            [habitsArr addObject:habits];
        }
        [self.keepHabitsArr addObjectsFromArray:habitsArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 数据加载完毕之后，结束更新
            [keepTableView.mj_footer endRefreshing];
            [keepTableView.mj_header endRefreshing];
            [keepTableView reloadData];
        });
        
//        [self analysisDataWithResponseObject:responseObject CommentsArr:self.keepCommentsArr PropsArr:self.keepPropsArr NoteArr:self.keepNoteArr NotesArr:self.keepNotesArr UsersArr:self.keepUsersArr HabitsArr:self.keepHabitsArr];
        
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
                                 //detail=1&flag=0&user_id=1850869
//                                 detail=1&flag=1&next_id=18162615&user_id=1850878
                                 };
    [session POST:APIAllNotesByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"ok === %@", responseObject);
//                ULog(@"%@", responseObject);
        
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            Notes *notes = [[Notes alloc] init];
            [notes setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *commentsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *commentsDict in dict[@"comments"]) {
                Comments *comments = [[Comments alloc] init];
                [comments setValuesForKeysWithDictionary:commentsDict];
                //                [self.commentsArr addObject:comments];
                [commentsArr addObject:comments];
            }
            // 判断上拉还是下拉
//            if (isNewRefresh == 1) {
//                [commentsArr addObjectsFromArray:self.NewCommentsArr];
//                self.NewCommentsArr = commentsArr;
//            }
//            else
                [self.NewCommentsArr addObjectsFromArray:commentsArr];
            
            NSMutableArray *propsArr = [[NSMutableArray alloc] init];
            for (NSDictionary *propsDict in dict[@"props"]) {
                Props *props = [[Props alloc] init];
                [props setValuesForKeysWithDictionary:propsDict];
                //                [self.propsArr addObject:props];
                [propsArr addObject:props];
            }
//            if (isNewRefresh == 1) {
//                [propsArr addObjectsFromArray:self.NewPropsArr];
//                self.NewPropsArr = propsArr;
//            }
//            else
                [self.NewPropsArr addObjectsFromArray:propsArr];
            
            NSMutableArray *noteArr = [[NSMutableArray alloc] init];
            noteArr = dict[@"note"];
//            if (isNewRefresh == 1) {
//                [noteArr addObjectsFromArray:self.NewNoteArr];
//                self.NewNoteArr = noteArr;
//            }
//            else
                [self.NewNoteArr addObjectsFromArray:noteArr];
            
            // 存储刷新ID
            if (isNewRefresh == 0) {
                Note *note = dict[@"note"];
                self.NewNextId =[note valueForKey:@"id"];
                //            NSLog(@"%@", self.keepNextId);
            }
            
            NSMutableArray *notesArr = [[NSMutableArray alloc] init];
            [notesArr addObject:notes];
//            if (isNewRefresh == 1) {
//                [notesArr addObjectsFromArray:self.NewNotesArr];
//                self.NewNotesArr = notesArr;
//            }
//            else
                [self.NewNotesArr addObjectsFromArray:notesArr];
        }
        
        NSMutableArray *usersArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dict];
            [usersArr addObject:users];
        }
        if (isNewRefresh == 1) {
            [usersArr addObjectsFromArray:self.NewUsersArr];
            self.usersArr = usersArr;
        }
        else
            [self.NewUsersArr addObjectsFromArray:usersArr];
        
        NSMutableArray *habitsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"data"][@"habits"]) {
            Habits *habits = [[Habits alloc] init];
            [habits setValuesForKeysWithDictionary:dict];
            //            [self.habitsArr addObject:habits];
            [habitsArr addObject:habits];
        }
        if (isNewRefresh == 1) {
            [habitsArr addObjectsFromArray:self.NewHabitsArr];
            self.NewHabitsArr = habitsArr;
        }
        else
            [self.NewHabitsArr addObjectsFromArray:habitsArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 数据加载完毕之后，结束更新
            [newestTableView.mj_footer endRefreshing];
            [newestTableView.mj_header endRefreshing];
            // 刷新tableView
            [newestTableView reloadData];
        });
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

#pragma mark 热门轮播图
- (void)createXRCarousel {
    
    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    //    [self.view addSubview:self.carouselView];
    
    self.carouselView.imageArray = @[@"cat.png", @"panda.png"];
    self.carouselView.time = 2;
    
}

// 退出登录
//- (IBAction)logoutClick:(UIButton *)sender {
//    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
//        LoginViewController *loginVc = [[LoginViewController alloc]init];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
//            NSLog(@"登出成功");
//        }];
//    } failure:^(NSError *error) {
//        ULog(@"%@", error);
//    }];
//}

@end
