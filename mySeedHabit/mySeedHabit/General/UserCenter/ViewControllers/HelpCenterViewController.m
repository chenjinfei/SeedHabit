//
//  HelpCenterViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HelpCenterViewController.h"

#import "HelpCenterDetailViewController.h"

#import <Masonry.h>

@interface HelpCenterViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
// 数据源
@property (nonatomic, strong) NSArray *dataSource;

// 数据源
@property (nonatomic, strong) NSArray *urlArr;

// 操作栏
@property (nonatomic, strong) UIView *handleView;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

-(NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated {
    [self buildView];
    [self loadData];
}


/**
 *  加载数据
 */
-(void)loadData {
    
    self.dataSource = @[
                        @"设置的闹钟提醒为什么不响？",
                        @"如何签到/取消签到？",
                        @"如何对习惯进行排序？",
                        @"在哪里看种子的生长状况？",
                        @"plank计时器在哪里？",
                        @"什么是习惯存档？",
                        @"错过打卡时间怎样补签？",
                        @"忘记帐号怎么办？"
                        ];
    self.urlArr = @[
                    @"http://mod.idothing.com/?p=75",
                    @"http://mod.idothing.com/?p=98",
                    @"http://mod.idothing.com/?p=14",
                    @"http://mod.idothing.com/?p=16",
                    @"http://mod.idothing.com/?p=18",
                    @"http://mod.idothing.com/?p=20",
                    @"http://mod.idothing.com/?p=22",
                    @"http://mod.idothing.com/?p=24"
                    ];
    
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HelpCell"];
    self.tableView.backgroundColor = RGBA(245, 245, 245, 1);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HelpCell"];
    
    // 创建悬浮操作栏
    self.handleView = [[UIView alloc]init];
    self.handleView.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:self.handleView];
    
    [self.handleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.mas_offset(0);
        make.left.equalTo(self.view.mas_left).with.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *moreQuestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreQuestionBtn setTitle:@"更多问题" forState:UIControlStateNormal];
    moreQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [moreQuestionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [moreQuestionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [moreQuestionBtn setImage:IMAGE(@"list_16.png") forState:UIControlStateNormal];
    moreQuestionBtn.imageEdgeInsets = UIEdgeInsetsMake(12, -6, 12, moreQuestionBtn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    [moreQuestionBtn addTarget:self action:@selector(moreQuestionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleView addSubview:moreQuestionBtn];
    
    [moreQuestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handleView.mas_top).with.mas_offset(0);
        make.left.equalTo(self.handleView.mas_left).with.mas_offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UIButton *suggestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [suggestionBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
    suggestionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [suggestionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [suggestionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [suggestionBtn setImage:IMAGE(@"msg_16.png") forState:UIControlStateNormal];
    suggestionBtn.imageEdgeInsets = UIEdgeInsetsMake(12, -6, 12, suggestionBtn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    [suggestionBtn addTarget:self action:@selector(suggestionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleView addSubview:suggestionBtn];
    
    [suggestionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handleView.mas_top).with.mas_offset(0);
        make.right.equalTo(self.handleView.mas_right).with.mas_offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UIButton *bugBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bugBtn setTitle:@"BUG反馈" forState:UIControlStateNormal];
    bugBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bugBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [bugBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [bugBtn setImage:IMAGE(@"bug_16.png") forState:UIControlStateNormal];
    bugBtn.imageEdgeInsets = UIEdgeInsetsMake(12, -6, 12, bugBtn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    [bugBtn addTarget:self action:@selector(bugBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleView addSubview:bugBtn];
    
    [bugBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handleView.mas_top).with.mas_offset(0);
        make.right.equalTo(self.handleView.mas_right).with.mas_offset(-SCREEN_WIDTH/3);
        make.left.equalTo(self.handleView.mas_left).with.mas_offset(SCREEN_WIDTH/3);
        make.height.mas_equalTo(40);
    }];
    
    
    
}


// 更多问题
-(void)moreQuestionBtnAction: (UIButton *)sender {
    NSLog(@"更多问题");
}


// BUG反馈
-(void)bugBtnAction: (UIButton *)sender {
    NSLog(@"BUG反馈");
}


// 意见反馈
-(void)suggestionBtnAction: (UIButton *)sender {
    NSLog(@"意见反馈");
}


/**
 *  跳转到视图控制器的方法
 *
 *  @param indexPath 标识
 */
-(void)switchToViewControllerWithIndexPath: (NSIndexPath*)indexPath {
    
    HelpCenterDetailViewController *hcdVc = [[HelpCenterDetailViewController alloc]init];
    hcdVc.url = self.urlArr[indexPath.row];
    [self.navigationController pushViewController:hcdVc animated:YES];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpCell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self switchToViewControllerWithIndexPath:indexPath];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)];
    sectionTitle.text = @"常见问题";
    sectionTitle.font = [UIFont systemFontOfSize:13];
    sectionTitle.textColor = [UIColor lightGrayColor];
    [titleView addSubview:sectionTitle];
    
    return titleView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

@end
