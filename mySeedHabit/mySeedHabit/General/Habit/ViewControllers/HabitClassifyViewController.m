//
//  HabitClassifyViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HabitClassifyViewController.h"
#import "Masonry.h"
#import "TabPageScrollView.h"
#import "HabitClassifyModel.h"
#import "HabitClassifyCell.h"
#import "HabitJoinListViewController.h"
#import "HabitJoinListViewController.h"

@interface HabitClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,TabPageScrollViewDelegate>

@property (nonatomic,strong)TabPageScrollView *pageScrollView;

@property (nonatomic,strong)UITableView *hotTabView;
@property (nonatomic,strong)UITableView *healthTabView;
@property (nonatomic,strong)UITableView *sportTabView;
@property (nonatomic,strong)UITableView *studyTabView;
@property (nonatomic,strong)UITableView *efficiencyTabView;
@property (nonatomic,strong)UITableView *thindTabView;

@property (nonatomic,strong)NSMutableArray *hotArr;
@property (nonatomic,strong)NSMutableArray *healthArr;
@property (nonatomic,strong)NSMutableArray *sportArr;
@property (nonatomic,strong)NSMutableArray *studyArr;
@property (nonatomic,strong)NSMutableArray *efficiencyArr;
@property (nonatomic,strong)NSMutableArray *thindArr;
@property (nonatomic,strong)NSMutableArray *allArr;

@end


@implementation HabitClassifyViewController

- (NSMutableArray *)hotArr
{
    if (_hotArr == nil) {
        _hotArr = [[NSMutableArray alloc]init];
    }
    return _hotArr;
}
- (NSMutableArray *)sportArr
{
    if (_sportArr == nil) {
        _sportArr = [[NSMutableArray alloc]init];
    }
    return _sportArr;
}
- (NSMutableArray *)studyArr
{
    if (_studyArr == nil) {
        _studyArr = [[NSMutableArray alloc]init];
    }
    return _studyArr;
}
- (NSMutableArray *)efficiencyArr
{
    if (_efficiencyArr == nil) {
        _efficiencyArr = [[NSMutableArray alloc]init];
    }
    return _efficiencyArr;
}
- (NSMutableArray *)thindArr
{
    if (_thindArr == nil) {
        _thindArr = [[NSMutableArray alloc]init];
    }
    return _thindArr;
}
- (NSMutableArray *)healthArr
{
    if (_healthArr == nil) {
        _healthArr = [[NSMutableArray alloc]init];
    }
    return _healthArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allArr = [[NSMutableArray alloc] init];
    [self buildUI];
    // 获取6个tableView所需要的数据数组
    [self getData:1];
    [self getData:2];
    [self getData:3];
    [self getData:4];
    [self getData:5];
    [self getData:6];
}

#pragma mark 创建UI界面
- (void)buildUI
{
    self.title = @"习惯分类";
    self.hotTabView = [self createTableViewWithIndentifier:@"hot"];
    self.healthTabView = [self createTableViewWithIndentifier:@"health"];
    self.sportTabView = [self createTableViewWithIndentifier:@"sport"];
    self.studyTabView = [self createTableViewWithIndentifier:@"study"];
    self.efficiencyTabView = [self createTableViewWithIndentifier:@"efficiency"];
    self.thindTabView = [self createTableViewWithIndentifier:@"thind"];
    
    // 创建pageScrollView
    NSArray *pageItems = @[
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"热门" andTabView:self.hotTabView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"健康" andTabView:self.healthTabView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"运动" andTabView:self.sportTabView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"学习" andTabView:self.studyTabView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"效率" andTabView:self.efficiencyTabView],
                           [[TabPageScrollViewPageItem alloc]initWithTabName:@"思考" andTabView:self.thindTabView]
                           ];
    _pageScrollView = [[TabPageScrollView alloc]initWithPageItems:pageItems];
    self.view.backgroundColor = RGB(255, 255, 255);
    UIView *rootView = self.view;
    [rootView addSubview:_pageScrollView];
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView.mas_top);
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        // 隐藏tabar要减掉tabar的高度
        make.bottom.equalTo(rootView.mas_bottom).offset(49);
    }];
    // 自定义返回按钮 详情
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"left_32.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark 创建tableView
- (UITableView *)createTableViewWithIndentifier:(NSString *)identifier
{
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [tableView registerClass:[HabitClassifyCell class] forCellReuseIdentifier:identifier];
    return  tableView;
}

#pragma mark 返回按钮方法
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取网络数据
/**
 *  获取6个tableView数据数组,再放在一个大数组
 *
 *  @param num post请求需要的一个参数:1~6
 */
- (void)getData:(int)num
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{
                                 @"classify_id":@(num),
                                 };
    [session POST:APIHabitClassify parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        // 获取每个tableView的数据,把数据放在一个临时数组
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in responseObject[@"data"][@"habits"]) {
            HabitClassifyModel *classify = [[HabitClassifyModel alloc]init];
            [classify setValuesForKeysWithDictionary:dic];
            NSLog(@"%@", classify.logo_url);
            [tempArr addObject:classify];
        }
        // 把临时数组对应赋给相应的tableView,没必要放到大数组中
        switch (num) {
            case 1:
                self.hotArr = tempArr;
                break;
            case 2:
                self.healthArr = tempArr;
                break;
            case 3:
                self.sportArr = tempArr;
                break;
            case 4:
                self.studyArr = tempArr;
                break;
            case 5:
                self.efficiencyArr = tempArr;
                break;
            case 6:
                self.thindArr = tempArr;
                break;
            default:
                break;
        }
        
        // 把临时数组有序的加到大数组
        [self.allArr addObject:tempArr];
        
        // 主线程刷新数据,UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hotTabView reloadData];
            [self.healthTabView reloadData];
            [self.sportTabView reloadData];
            [self.studyTabView reloadData];
            [self.efficiencyTabView reloadData];
            [self.thindTabView reloadData];
    });
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+++++++++%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.hotTabView]) {
        return self.hotArr.count;
    }
    if ([tableView isEqual:self.healthTabView]) {
        return self.healthArr.count;
    }
    if ([tableView isEqual:self.sportTabView]) {
        return self.sportArr.count;
    }
    if ([tableView isEqual:self.studyTabView]) {
        return self.studyArr.count;
    }
    if ([tableView isEqual:self.efficiencyTabView]) {
        return self.efficiencyArr.count;
    }
    if ([tableView isEqual:self.thindTabView]) {
        return self.thindArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark 返回cell方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.hotTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hot"];
        HabitClassifyModel *classify = self.hotArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    if ([tableView isEqual:self.healthTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"health"];
        HabitClassifyModel *classify = self.healthArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    if ([tableView isEqual:self.sportTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sport"];
        HabitClassifyModel *classify = self.sportArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    if ([tableView isEqual:self.studyTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"study"];
        HabitClassifyModel *classify = self.studyArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    if ([tableView isEqual:self.efficiencyTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"efficiency"];
        HabitClassifyModel *classify = self.efficiencyArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    if ([tableView isEqual:self.thindTabView]) {
        HabitClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thind"];
        HabitClassifyModel *classify = self.thindArr[indexPath.row];
        cell.classify = classify;
        return cell;
    }
    return nil;
}

#pragma mark 点击cell响应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HabitJoinListViewController *JoinListVC = [[HabitJoinListViewController alloc]init];
    // 第一页传习惯id到第三页
    JoinListVC.habitArray = self.habitArr;
    if ([tableView isEqual:self.hotTabView]) {
        HabitClassifyModel *classify = self.hotArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    if ([tableView isEqual:self.healthTabView]) {
        HabitClassifyModel *classify = self.healthArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    if ([tableView isEqual:self.sportTabView]) {
        HabitClassifyModel *classify = self.sportArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    if ([tableView isEqual:self.studyTabView]) {
        HabitClassifyModel *classify = self.studyArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    if ([tableView isEqual:self.efficiencyTabView]) {
        HabitClassifyModel *classify = self.efficiencyArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    if ([tableView isEqual:self.thindTabView]) {
        HabitClassifyModel *classify = self.thindArr[indexPath.row];
        JoinListVC.titleStr = classify.habit_name;
        JoinListVC.members = classify.members;
        JoinListVC.habit_idStr = classify.habit_id;
    }
    // 隐藏push到下个页面时下面的tabar
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:JoinListVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
