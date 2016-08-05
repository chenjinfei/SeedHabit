//
//  ContactsViewController.m
//  我的联系人
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

// 搜索框
@property (nonatomic, strong) UISearchController *searchController;
// 数据
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *dataList;
// 表格视图
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    
    
    
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64-49) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    // 搜索框
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [self.view addSubview:self.searchController.searchBar];
    
    for (int i =0; i<20; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}


@end
