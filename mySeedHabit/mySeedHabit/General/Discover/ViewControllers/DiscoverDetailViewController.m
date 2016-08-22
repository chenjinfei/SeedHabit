//
//  DiscoverDetailViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/20.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "UIColor+CJFColor.h"
#import "DiscoveTableViewCell.h"
#import "UserCenterViewController.h"
#import "PropsListViewController.h"
#import "TreeInfoViewController.h"
#import "AlbumViewController.h"
#import "CJFTools.h"
#import "UIImageView+CJFUIImageView.h"
#import <UIImageView+WebCache.h>

#import "UserManager.h"
#import "SeedUser.h"
#import "KeyboardObserved.h"

@interface DiscoverDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DiscoveTableViewCell *cell;

@property (nonatomic, strong) SeedUser *user;
@property (nonatomic, strong) NSString *mindNoteId;
// 键盘输入框
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *commentText;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) BOOL isDetail;


@end

@implementation DiscoverDetailViewController

- (NSMutableArray *)usersArr {

    if (_usersArr == nil) {
        _usersArr = [[NSMutableArray alloc] init];
    }
    return _usersArr;
}
- (NSMutableArray *)imageArr {

    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.user = [UserManager manager].currentUser;
    NSLog(@"%@", self.user.uId);
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    self.navigationItem.title = @"详情";
    
    [self createTableView];
    
    self.isDetail = YES;
    
    
}

#pragma mark =========创建UITableView==========
- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = RGB(245, 245, 245);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    
    self.cell.isDetail = self.isDetail;
    NSLog(@"%d", self.cell.isDetail);
   
    self.cell.imageArr = self.imageArr;
    self.cell.usersArr = self.usersArr;
    
    
    self.cell.notes = self.notes;
    self.cell.habits = self.habits;
    self.cell.users = self.users;
    
    self.cell.contentImageV.userInteractionEnabled=YES; // 开启imageView的响应方法
    
    return self.cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height= [self.cell Height];
    return height + 140;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
