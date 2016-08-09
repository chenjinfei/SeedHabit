//
//  PropsListViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "PropsListViewController.h"
#import "Users.h"
#import "PropsListTableViewCell.h"


@interface PropsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PropsListViewController

- (NSMutableArray *)dataArr {

    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {

//    self.view.backgroundColor = [UIColor colorWithRed:0 green:168/255.0 blue:130/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:168/255.0 blue:130/255.0 alpha:1];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    self.navigationItem.title = @"点赞列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PropsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PropsCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PropsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropsCell"];
    
    cell.users = self.dataArr[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
    
}

#pragma mark 加载数据
- (void)loadData {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    NSDictionary *parameters = @{
                                 @"mind_note_id":self.mind_note_id,
                                 @"user_id":self.user_id
                                 
//                                 点赞列表
//                                 http://api.idothing.com/zhongzi/v2.php/MindNote/getPropsList
//                                 mind_note_id=18602076&user_id=1850869
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/MindNote/getPropsList" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSArray *arr = responseObject[@"data"][@"users"];
        for (NSDictionary *dic in arr) {
            Users *users = [[Users alloc] init];
            [users setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:users];
        }
//        NSLog(@"%@", self.dataArr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
    
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
