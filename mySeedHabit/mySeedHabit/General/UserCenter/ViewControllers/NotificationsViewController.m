//
//  NotificationsViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "NotificationsViewController.h"

#import <Masonry.h>
#import "CJFPlaySound.h"

@interface NotificationsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7) { // ios7 一下
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]  == UIUserNotificationTypeNone) {
            NSLog(@"yes");
        }else {
            NSLog(@"no");
        }
    }else{ //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types ==UIUserNotificationTypeNone) {
            NSLog(@"yes");
        }else {
            NSLog(@"no");
        }
    }
    
    //    CJFPlaySound *playSound = [[CJFPlaySound alloc]initForPlayingVibrate];
    CJFPlaySound *playSound = [[CJFPlaySound alloc] init];
    [playSound play];
    
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
                        @"振动",
                        @"声音"
                        ];
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = @"消息提醒设置";
    self.view.backgroundColor = RGB(249, 249, 249);
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGB(249, 249, 249);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
}


#pragma mark tableview的代理方法实现

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    //实例化一个开关控件
    UISwitch *swi=[[UISwitch alloc]init];
    [cell.contentView addSubview:swi];
    
    UIView *superView = cell.contentView;
    [swi mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(5);
        make.right.equalTo(superView.mas_right).with.mas_offset(-20);
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
    headerTitle.text = @"设置是否需要接收新消息时的声音或振动提醒";
    headerTitle.font = [UIFont systemFontOfSize:12];
    headerTitle.textColor = [UIColor lightGrayColor];
    [headerView addSubview:headerTitle];
    return headerView;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel *footerTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 100)];
    footerTitle.text = @"如果你要关闭或开启金种子习惯的新消息通知，请在iPhone\"设置\"-\"通知\"功能中、找到应用程序\"金种子\"更改";
    footerTitle.numberOfLines = 0;
    footerTitle.font = [UIFont systemFontOfSize:12];
    footerTitle.textColor = [UIColor lightGrayColor];
    [footerView addSubview:footerTitle];
    return footerView;
}








@end
