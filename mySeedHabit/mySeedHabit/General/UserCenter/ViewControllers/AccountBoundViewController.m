//
//  AccountBoundViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AccountBoundViewController.h"

#import <Masonry.h>
#import "UIColor+CJFColor.h"

@interface AccountBoundViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation AccountBoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }
    return  _tableView;
}


/**
 *  加载数据
 */
-(void)loadData {
    self.dataSource = @[
                        @[
                            @"手机号"
                            ],
                        @[
                            @"QQ",
                            @"新浪微博"
                            ]
                        ];
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = @"帐号绑定";
    self.view.backgroundColor = RGB(249, 249, 249);
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGB(249, 249, 249);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UILabel *footerTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 60)];
    footerTitle.text = @"你可以使用做任意已绑定的帐号来登录";
    footerTitle.numberOfLines = 0;
    footerTitle.font = [UIFont systemFontOfSize:12];
    footerTitle.textColor = [UIColor lightGrayColor];
    [footerView addSubview:footerTitle];
    self.tableView.tableFooterView = footerView;
    
}


#pragma mark tableview的代理方法实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //实例化一个开关控件
    UILabel *boundStatus=[[UILabel alloc]init];
    boundStatus.text = @"未绑定";
    boundStatus.font = [UIFont systemFontOfSize:12];
    boundStatus.textColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    [cell.contentView addSubview:boundStatus];
    
    UIView *superView = cell.contentView;
    [boundStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(0);
        make.right.equalTo(superView.mas_right).with.mas_offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}





@end
