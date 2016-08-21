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
    
}

#pragma mark =========创建UITableView==========
- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+64) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    
    self.cell.imageArr = self.imageArr;
    self.cell.usersArr = self.usersArr;
    
    
    self.cell.notes = self.notes;
    self.cell.habits = self.habits;
    self.cell.users = self.users;
    
    self.cell.contentImageV.userInteractionEnabled=YES; // 开启imageView的响应方法
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.cell.contentImageV addGestureRecognizer:singleTap];
    
    
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

#pragma mark TableViewCell.btn 代理事件 Push -- 点赞列表、信息树、专辑、习惯、头像跳转、图片放大
- (void)onClickImage {

    NSLog(@"onClickImage");
    self.navigationController.navigationBarHidden = YES;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.mainScrollView.contentSize = CGSizeMake(0, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.mainScrollView.bounds];
    [imageView lhy_loadImageUrlStr:[self.notes.note valueForKey:@"mind_pic_big"] placeHolderImageName:@"placeHolder.png" radius:0];
    [self.mainScrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.mainScrollView.center;
    imageView.userInteractionEnabled = YES;
    
    self.mainScrollView.minimumZoomScale = 1;
    self.mainScrollView.maximumZoomScale = 3;
    self.mainScrollView.zoomScale = 1;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickScroll)];
    [self.mainScrollView addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    //    触发长按最小时间
    longPress.minimumPressDuration = 1.5;
    [imageView addGestureRecognizer:longPress];

}
- (void)onClickScroll {
    [self.mainScrollView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}
- (void)longAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存图片到相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.notes.note valueForKey:@"mind_pic_big"]];
        UIImageWriteToSavedPhotosAlbum(cacheImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];// 添加按钮到警示框上面

    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark 将图片保存到本地
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
    
}

#pragma mark 告诉缩放的是哪个 View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews objectAtIndex:0];
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
