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
#import "UIColor+CJFColor.h"
#import "NSString+CJFString.h"

#import<Masonry.h>

@interface TreeInfoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *note;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *treeImage;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int day;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;

@end

@implementation TreeInfoViewController

#pragma mark 离开这个页面之后停止计时器
- (void)viewDidDisappear:(BOOL)animated {
    
    [self.timer invalidate];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
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
        
        if ([responseObject[@"status"] integerValue] == 0) {
        
            TreeInfo *tree = [[TreeInfo alloc] init];
            tree = responseObject[@"data"];
            
            self.note.text = [tree valueForKey:@"note"];
            [self.treeImage sd_setImageWithURL:[NSURL URLWithString:[tree valueForKey:@"tree_address"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            // 时间戳转换
            // 用户发表时间
            NSString *timeS = [NSString stringWithFormat:@"%@", [tree valueForKey:@"start_time"]];
            NSTimeInterval time = [timeS doubleValue];
            NSDate *detail = [NSDate dateWithTimeIntervalSince1970:time];
            NSDate *new = [NSDate date];
            NSTimeInterval interval = [new timeIntervalSinceDate:detail];
            
            self.second = (int)interval % 60;
            self.minute = (int)interval / 60 % 60;
            self.hour = (int)interval / 3600 % 24;
            self.day = (int)interval / 3600 / 24;
    //        self.time.text = [NSString stringWithFormat:@"%d  :  %d  :  %d  :  %d", self.day, self.hour, self.minute, self.second];
            
            // 开启定时器
            [self addTimer];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
    
}
- (void)addTimer {

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}
- (void)timerAction {

    self.second++;
    if (self.second == 60) {
        self.second = 0;
        self.minute++;
        if (self.minute == 60) {
            self.minute = 0;
            self.hour++;
            if (self.hour == 24) {
                self.hour = 0;
                self.day++;
            }
        }
    }
    self.time.text = [NSString stringWithFormat:@"%d  :  %0.2d  :  %0.2d  :  %0.2d", self.day, self.hour, self.minute, self.second];
    
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
