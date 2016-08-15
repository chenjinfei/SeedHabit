//
//  UserInfoUpdateViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserInfoViewController.h"

#import "UserInfo_LabelImage.h"
#import "SeedUser.h"
#import "UserManager.h"
#import "LoginViewController.h"
#import "AvatarUpdateViewController.h"
#import "UserInfoUpdateViewController.h"

#import <UIImageView+WebCache.h>
#import "UIImage+CJFImage.h"
#import "UIImageView+CJFUIImageView.h"
#import "CJFTools.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UserInfo_LabelImage *tableHeaderView;
@property (nonatomic, strong) SeedUser *user;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图
    [self buildView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
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
    
    self.user = [UserManager manager].currentUser;
    [self.tableHeaderView.avatarView lhy_loadImageUrlStr:self.user.avatar_small placeHolderImageName:@"placeHolder.png" radius:self.tableHeaderView.avatarView.frame.size.height/2];
    
    NSArray *arrFirst = [NSArray arrayWithObjects:@"昵称", @"性别", @"生日", nil];
    NSArray *arrSecond = [NSArray arrayWithObjects:@"签名", nil];
    
    NSArray *menuArr = nil;
    if (self.user.account_type == 4) {
        NSArray *arrThird = [NSArray arrayWithObjects:@"修改密码", nil];
        menuArr = [NSArray arrayWithObjects:arrFirst, arrSecond, arrThird, nil];
    }else {
        menuArr = [NSArray arrayWithObjects:arrFirst, arrSecond, nil];
    }
    
    if (self.dataArr != nil) {
        [self.dataArr removeAllObjects];
    }
    
    [self.dataArr addObjectsFromArray:menuArr];
    
    [self.tableView reloadData];
    
}

-(void)buildView {
    
    self.navigationItem.title = @"个人资料";
    
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    self.tableView.separatorColor = RGBA(235, 235, 235, 1);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"UserInfo_LabelImage" owner:self options:nil][0];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.tableHeaderView.textView.text = @"头像";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateAvatar:)];
    [self.tableHeaderView addGestureRecognizer:tap];
    
}



/**
 *  更换头像按钮点击响应方法
 *
 *  @param Ges 手势对象
 */
-(void)updateAvatar: (UITapGestureRecognizer *)Ges {
    
    AvatarUpdateViewController *avatarUpateVc = [[AvatarUpdateViewController alloc]init];
    [self presentViewController:avatarUpateVc animated:YES completion:nil];
    
}



// 修改密码
- (void)logoutClick:(UIButton *)sender {
    
    UserInfoUpdateViewController *updateVc = [[UserInfoUpdateViewController alloc]init];
    updateVc.flag = @"0";
    updateVc.user = self.user;
    [self.navigationController pushViewController:updateVc animated:YES];
    
}

#pragma mark tableView代理方法的实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SETUPMENU";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == self.dataArr.count-1 && self.user.account_type == 4) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LASTCELL"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.user.nickname;
            }else if (indexPath.row == 1) {
                NSString *gender = nil;
                if (self.user.gender) {
                    gender = @"男";
                }else {
                    gender = @"女";
                }
                cell.detailTextLabel.text = gender;
            }else if (indexPath.row == 2) {
                if (self.user.birthday) {
                    cell.detailTextLabel.text = [[CJFTools manager]revertTimeamp:[NSString stringWithFormat:@"%ld", self.user.birthday] withFormat:@"yyyy/MM/dd"];
                }else {
                    cell.detailTextLabel.text = @"未填写";
                }
            }
            
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.user.signature;
            }
        }
        
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == self.dataArr.count - 1) {
        [self logoutClick:nil];
    }else {
        
        UserInfoUpdateViewController *updateVc = [[UserInfoUpdateViewController alloc]init];
        updateVc.flag = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row+1];
        updateVc.user = self.user;
        [self.navigationController pushViewController:updateVc animated:YES];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end
