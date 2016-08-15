//
//  AlbumViewController.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/10.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "AlbumViewController.h"
#import "AppTools.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "UIColor+CJFColor.h"

@interface AlbumViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat noteHeight;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation AlbumViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 掩盖导航
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, -64, 414, 64)];
    [self.view addSubview:vi];
    vi.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1.0];
    
    // 自适应
    [self loadContentView];
    
    self.dayNumber.text = self.day;
    self.insist.text = self.insistText;
    self.author.text = self.authorText;
    self.publish.text = self.publishText;
    
    NSLog(@"%f, %f, %f", self.view.frame.size.height, self.scrollView.frame.size.height, self.contentView.frame.size.height);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightAction)];
    
}

- (void)rightAction {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存" message:@"您是否保存这张图片" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        /**
         *  将图片保存到 本地相册
         *  @param getImageFromView:self.view]                                   传递一个 image
         */
         UIImageWriteToSavedPhotosAlbum([self getImageFromView:self.view], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 将 view 转换为 iamge
-(UIImage *)getImageFromView:(UIView *)theView
{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    // 使接收机及其子层到指定的上下文。图形上下文使用呈现层。参数ctx图形上下文使用呈现层。
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 返回一个图像基于当前基于位图的图形上下文的内容。一个图片对象包含当前位图图形上下文的内容。返回一个图片对象包含当前位图图形上下文的内容。
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 将图片保存到本地
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
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

#pragma mark 建立 自适应
- (void)loadContentView {
    
    // 建立Label
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    
    // 建立UIIMageView
    self.imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageV];
    
    if (self.imageUrl) {
        
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageUrl];
        self.imageHeight =  [AppTools imageHeightWithImage:cacheImage width:self.contentView.bounds.size.width];
        self.imageV.image = cacheImage;
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
             
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width, self.imageHeight));
            make.top.mas_equalTo(self.contentView).with.offset(20);
            make.left.mas_equalTo(self.contentView).with.offset(0);
            if (self.mind_note.length == 0) {
                make.bottom.mas_equalTo(self.contentView).with.offset(-20);
            }
        }];
    }
    else
        self.imageHeight = 0;
    
    if (self.mind_note.length > 0) {
        self.noteHeight = [AppTools heightWithString:self.mind_note width:self.contentView.bounds.size.width font:[UIFont boldSystemFontOfSize:17]];
        NSLog(@"%f", self.noteHeight);
        
        // 设置 LAbel
        self.label.text = self.mind_note;
        self.label.numberOfLines = 10;
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.contentView).with.offset(0);
             make.right.mas_equalTo(self.contentView).with.offset(0);
            if (self.imageUrl) {
                make.top.mas_equalTo(self.imageV.mas_bottom);
            }
            else
                make.top.mas_equalTo(self.contentView).with.offset(20);
            
            make.bottom.mas_equalTo(self.contentView).with.offset(-20);
        }];
    }
    else
        self.noteHeight = 0;
    
}

#pragma mark //UIImage -> PNG / JPG
- (void)makingImage:(UIImage *)image {

    NSString *pngPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString *jpgPath =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject]);
    [UIImageJPEGRepresentation(image,1.0) writeToFile:jpgPath atomically:YES];
    
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    // Let's check to see if files were successfully written...
    // Create file manager
    NSError*error;
    NSFileManager*fileMgr=[NSFileManager defaultManager];
    
    // Point to Document directory
    NSString*documentsDirectory =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documentsdirectory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

#pragma mark 更新约束
- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    self.viewHeight.constant = self.imageHeight + self.noteHeight + 181 + 10 + 20 + 20;
    
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
