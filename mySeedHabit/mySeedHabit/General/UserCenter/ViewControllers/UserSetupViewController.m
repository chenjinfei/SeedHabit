//
//  UserSetupViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserSetupViewController.h"

#import "UserInfo_LabelImage.h"
#import "SeedUser.h"
#import "UserManager.h"
#import "LoginViewController.h"

#import <UIImageView+WebCache.h>
#import "UIImage+CJFImage.h"
#import "UIImageView+CJFUIImageView.h"

@interface UserSetupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UserInfo_LabelImage *tableHeaderView;

@end

@implementation UserSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图
    [self buildView];
    
    // 加载数据
    [self loadData];
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(void)loadData {
    
    NSArray *arrFirst = [NSArray arrayWithObjects:@"我的收藏", @"帐号绑定", @"帮助中心", @"消息提醒管理", nil];
    NSArray *arrSecond = [NSArray arrayWithObjects:@"关于种子习惯", nil];
    NSArray *arrThird = [NSArray arrayWithObjects:@"退出帐号", nil];
    
    NSArray *menuArr = [NSArray arrayWithObjects:arrFirst, arrSecond, arrThird, nil];
    
    [self.dataArr addObjectsFromArray:menuArr];
    
    SeedUser *user = [UserManager manager].currentUser;
    [self.tableHeaderView.avatarView lhy_loadImageUrlStr:user.avatar_small placeHolderImageName:@"placeHolder.png" radius:self.tableHeaderView.avatarView.frame.size.height/2];
    
}

-(void)buildView {
    
    self.navigationItem.title = @"设置";
    
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    self.tableView.separatorColor = RGBA(235, 235, 235, 1);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SETUPMENU"];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"UserInfo_LabelImage" owner:self options:nil][0];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.tableHeaderView.textView.text = @"编辑个人资料";
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SETUPMENU"];
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    if (indexPath.section == self.dataArr.count-1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == self.dataArr.count - 1) {
        [self logoutClick:nil];
    }
}


// 退出登录
- (void)logoutClick:(UIButton *)sender {
    [[UserManager manager] logoutSuccess:^(NSDictionary *responseObject) {
        
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVc animated:YES completion:^{
            NSLog(@"登出成功");
        }];
        
    } failure:^(NSError *error) {
        
        ULog(@"%@", error);
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}



@end
