//
//  AddNoteViewController.m
//  mySeedHabit
//
//  Created by lanou on 16/8/15.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Masonry.h"
#import "CJFTools.h"
#import "UserManager.h"
#import "SeedUser.h"

#define APIAddMindNote @"http://api.idothing.com/zhongzi/v2.php/MindNote/addNote"

@interface AddNoteViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIButton *picBtn;
@property (nonatomic,strong)UIImageView *myNoteImageView;
@property (nonatomic,strong)SeedUser *user;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    self.user = [[UserManager manager] currentUser];
}

#pragma mark 创建UI界面
- (void)buildUI
{
    self.title = @"记录一下";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *quotationV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quotation.png"]];
    quotationV.frame = CGRectMake(0, 0, 15, 15);
    [self.view addSubview:quotationV];
    self.textView = [[UITextView alloc]init];
    self.textView.text = @"  ";
    self.textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@150);
    }];
    
    self.picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.picBtn setImage:[UIImage imageNamed:@"background.jpg"] forState:UIControlStateNormal];
    self.picBtn.backgroundColor = [UIColor whiteColor];
    [self.picBtn setTitle:@"添加照片" forState:UIControlStateNormal];
    [self.picBtn addTarget:self action:@selector(addPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.picBtn];
    [self.picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.mas_equalTo(@(SCREEN_WIDTH - 40));
        make.height.mas_equalTo(@(250));
    }];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    finishBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 15, 50, 30);
    [finishBtn setTitle:@"发送" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem = finishItem;
}

#pragma mark 点击发送按钮发送心情内容
- (void)submitAction
{
    NSInteger newHabit_id = [self.habit_idStr integerValue];
    NSDictionary *parameter;
    if (self.textView.text == nil) {
        parameter = @{
                                    @"check_in_id": self.check_in_id,
                                    @"habit_id":[NSNumber numberWithInteger:newHabit_id],
                                    @"mind_pic":self.myNoteImageView.image,
                                    @"user_id":@1878988
                                    };
    }
    if (self.myNoteImageView.image == nil) {
        parameter = @{
                                    @"check_in_id": self.check_in_id,
                                    @"habit_id":[NSNumber numberWithInteger:newHabit_id],
                                    @"mind_note":self.textView.text,
                                    @"user_id":@1878988
                                    };
    }
    if (self.textView.text != nil && self.myNoteImageView.image != nil) {
        parameter = @{
                                    @"check_in_id": self.check_in_id,
                                    @"habit_id":[NSNumber numberWithInteger:newHabit_id],
                                    @"mind_note":self.textView.text,
                                    @"mind_pic":self.myNoteImageView.image,
                                    @"user_id":[NSString stringWithFormat:@"%@", self.user.uId]
                                    };
    }
    [[CJFTools manager] submitFormDataToUrl:APIAddMindNote withParameters:parameter exImgParameterName:@"mind_pic"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 打开相册按钮
- (void)addPicAction
{
    //1.创建相册视图控制器
    UIImagePickerController *imagePickVC = [[UIImagePickerController alloc]init];
    
    //2.设置代理
    imagePickVC.delegate = self;
    
    //3.开启编辑模式
    imagePickVC.allowsEditing = YES;
    
    //4.设置媒体类型
    imagePickVC.mediaTypes = @[@"public.image"];
    
    //5.设置设备源类型
    imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //6.打开系统相册
    [self presentViewController:imagePickVC animated:YES completion:nil
     ];
}

#pragma mark 实现图片代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.myNoteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 40, 300)];
    self.myNoteImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.myNoteImageView];
    self.myNoteImageView.image = image;
    // 关闭模态
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
