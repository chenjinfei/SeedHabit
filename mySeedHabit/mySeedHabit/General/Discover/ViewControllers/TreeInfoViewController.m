//
//  TreeInfoViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/9.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "TreeInfoViewController.h"

#import "TreeInfo.h"
#import <UIImageView+WebCache.h>

@interface TreeInfoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *note;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *treeImage;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TreeInfoViewController

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {

    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    self.navigationItem.title = self.treeTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"omit2_32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    
}

- (void)rightAction {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"签到可以帮助种子成长，连续7天不签到，你的种子将会死亡" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadData {

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"habit_id":self.habit_id,
                                 @"user_id":self.user_id
                                 
//                                  种子树信息
//                                http://api.idothing.com/zhongzi/v2.php/mindNote/getTreeInfo
//                                 habit_id=644198&user_id=1847514
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/mindNote/getTreeInfo" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

//        NSArray *arr = responseObject[@"data"];
//        for (NSDictionary *dic in arr) {
//            TreeInfo *tree = [[TreeInfo alloc] init];
//            [tree setValuesForKeysWithDictionary:dic];
//            [self.dataArr addObject:tree];
//        }
        
        TreeInfo *tree = [[TreeInfo alloc] init];
        tree = responseObject[@"data"];
        
        self.note.text = [tree valueForKey:@"note"];
        [self.treeImage sd_setImageWithURL:[NSURL URLWithString:[tree valueForKey:@"tree_address"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        // 时间戳转换
        // 用户发表时间
//        NSString *timeS = [NSString stringWithFormat:@"%@", [tree valueForKey:@"start_time"]];
//        NSTimeInterval time = [timeS doubleValue];
//        NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
//         NSLog(@"date:%@", [detail description]);
//        NSDateFormatter *date = [[NSDateFormatter alloc] init];
//        //        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [date setDateFormat:@"HH:mm:ss"];
//        NSString *old = [date stringFromDate:detail];
//        
//        NSDate *new = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
//        
//        NSTimeInterval interval = [new timeIntervalSinceDate:detail];
//        
////        int second = interval % 60;
////        int minute = interval / 60;
////        int day = interval
////        
////        self.time.text = [NSString stringWithFormat:@"%d : %d : %d : %d", day, hour, minute, second];
//        
//        self.time.text = new;
        
//        self.time.text = curr;
        //         NSLog(@"%@", curr);
        // 当前时间
        //        NSDate *nowDate = [NSDate date];
        // 时间间隔
        //        double interval = [nowDate timeIntervalSinceDate:detail];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
    
}

// 判断闰年
//+(BOOL)bissextile:(int)year {
//    if ((year%4==0 && year %100 !=0) || year%400==0) {
//        return YES;
//    }else {
//        return NO;
//    }
//    return NO;
//}

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
