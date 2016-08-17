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
#import "UserInfoViewController.h"

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
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // 加载数据
    [self loadData];
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
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
    NSArray *arrSecond = [NSArray arrayWithObjects:@"清除缓存", @"关于种子习惯", nil];
    NSArray *arrThird = [NSArray arrayWithObjects:@"退出帐号", nil];
    
    NSArray *menuArr = [NSArray arrayWithObjects:arrFirst, arrSecond, arrThird, nil];
    [self.dataArr removeAllObjects];
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
    
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SETUPMENU"];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"UserInfo_LabelImage" owner:self options:nil][0];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.tableHeaderView.textView.text = @"编辑个人资料";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateUserInfo:)];
    [self.tableHeaderView addGestureRecognizer:tap];
    
}


// 用户信息修改
-(void)updateUserInfo: (UITapGestureRecognizer *)tap {
    
    self.hidesBottomBarWhenPushed = YES;
    UserInfoViewController *infoVc = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:infoVc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
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

/**
 *  cell操作处理方法
 *
 *  @param section 分区号
 *  @param row     行号
 */
-(void)switchActionWithSection: (NSInteger)section row: (NSInteger)row {
    
    NSInteger actionFlag = [[NSString stringWithFormat:@"%ld%ld", section, row] integerValue];
    switch (actionFlag) {
        case 00:{// 我的收藏
            
            break;
        }
        case 01:{// 帐号绑定
            
            break;
        }
        case 02:{// 帮助中心
            
            break;
        }
        case 03:{// 消息提醒设置
            
            break;
        }
        case 10:{// 清除缓存
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self clearCache];
                [self.tableView reloadData];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:clearAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 11:{// 关于种子习惯
            
            break;
        }
        default:
            break;
    }
    
}

// 获取缓存大小
-(CGFloat)getCachedSize {
    //计算检查缓存大小: 单位：b
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    return tmpSize;
}

//清除缓存
- (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
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
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.section == 1 && indexPath.row == 0){
        CGFloat tmpSize = [self getCachedSize];
        tmpSize /= (1024*1024);
        NSString * clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:clearCacheName];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, clearCacheName.length)];
        cell.detailTextLabel.attributedText = AttributedStr;
    }
    if (indexPath.section == self.dataArr.count-1) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == self.dataArr.count - 1) {
        [self logoutClick:nil];
    }else {
        [self switchActionWithSection:indexPath.section row:indexPath.row];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}





@end
