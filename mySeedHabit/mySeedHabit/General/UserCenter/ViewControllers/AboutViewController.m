//
//  AboutViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AboutViewController.h"

#import "UIColor+CJFColor.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "ProtocolViewController.h"
#import "ContactUsViewController.h"

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadData];
}



/**
 *  加载数据
 */
-(void)loadData {
    self.dataSource = @[
                        @"去评论",
                        @"清除缓存",
                        @"联系我们",
                        @"使用协议"
                        ];
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = @"关于金种子";
    self.view.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    
    // 去掉导航栏的黑线
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*3/9)];
    bgView.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1];
    self.tableView.tableHeaderView = bgView;
    
    UILabel *version = [[UILabel alloc]init];
    version.text = @"Version 1.0.0";
    version.textColor = [UIColor whiteColor];
    version.font = [UIFont systemFontOfSize:12];
    version.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:version];
    
    [version mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).with.mas_offset(-20);
        make.bottom.equalTo(bgView.mas_bottom).with.mas_offset(-30);
        make.left.equalTo(bgView.mas_left).with.mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *appName = [[UILabel alloc]init];
    appName.text = @"金种子";
    appName.textColor = [UIColor whiteColor];
    appName.font = [UIFont systemFontOfSize:14];
    appName.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:appName];
    
    [appName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).with.mas_offset(-20);
        make.bottom.equalTo(version.mas_top).with.mas_offset(0);
        make.left.equalTo(bgView.mas_left).with.mas_offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:IMAGE(@"logo_128.png")];
    [bgView addSubview:logoView];
    
    [logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*3/9);
        make.height.mas_equalTo(SCREEN_WIDTH*3/9);
        make.centerX.mas_equalTo(bgView);
        make.bottom.equalTo(appName.mas_top).with.mas_offset(0);
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
        case 00:{// 去评论
            
            NSLog(@"去评论");
            
            break;
        }
        case 01:{// 清除缓存
            
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
        case 02:{// 联系我们
            
            NSLog(@"联系我们");
            ContactUsViewController *cuVc = [[ContactUsViewController alloc]init];
            [self.navigationController pushViewController:cuVc animated:YES];
            
            break;
        }
        case 03:{// 使用协议
            
            NSLog(@"使用协议");
            ProtocolViewController *pcVc = [[ProtocolViewController alloc]init];
            [self.navigationController pushViewController:pcVc animated:YES];
            
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



#pragma mark tableview的代理方法实现


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SETUPMENU";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.row > 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 1){
        CGFloat tmpSize = [self getCachedSize];
        tmpSize /= (1024*1024);
        NSString * clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"缓存大小%.2fM",tmpSize] : [NSString stringWithFormat:@"缓存大小%.2fK",tmpSize * 1024];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:clearCacheName];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, clearCacheName.length)];
        cell.detailTextLabel.attributedText = AttributedStr;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self switchActionWithSection:indexPath.section row:indexPath.row];
    
}


//用 bounces 属性 去掉tableview向下的弹簧效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}



@end
