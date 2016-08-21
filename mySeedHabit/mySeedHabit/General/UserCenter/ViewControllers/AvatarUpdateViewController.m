//
//  AvatarUpdateViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/10/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "AvatarUpdateViewController.h"

#import "SeedUser.h"
#import "UserManager.h"
#import <UIImageView+WebCache.h>
#import <MobileCoreServices/UTType.h>
#import "UIImage+CJFImage.h"

#import "CJFTools.h"

#define POST_BOUNDS @"667AA1D3D3490DF4"

@interface AvatarUpdateViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 图片选择器
@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation AvatarUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self buildImgPicker];
    
    [self loadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/**
 *  加载数据
 */
-(void)loadData {
    
    SeedUser *user = [UserManager manager].currentUser;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar_big] placeholderImage:IMAGE(@"placeHolder.png")];
    
}

// 点击空白处退出模态控制器
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  配置视图
 */
-(void)buildView {
    
    [self.changeBtn addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveToLocaleBtn addTarget:self action:@selector(saveAvartarToLocal:) forControlEvents:UIControlEventTouchUpInside];
    
}


/**
 *  配置图片选择器
 */
-(void)buildImgPicker {
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
}


/**
 *  更换头像按钮点击响应方法
 *
 *  @param Ges 手势对象
 */
-(void)changeAvatar: (UITapGestureRecognizer *)Ges {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    // 照相机
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        [self presentViewController:self.picker animated:YES completion:nil];
        
    }];
    // 从相册中提取图片
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        [self presentViewController:self.picker animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/**
 *  当用户选取完成后调用
 *
 *  @param picker 图片选择器对象
 *  @param info   返回用户所选择的媒体信息
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断选择的媒体类型是否为图片
    if ([mediaType isEqualToString:@"public.image"]) {
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            
            //如果是 来自照相机的image，那么先保存
            UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImageWriteToSavedPhotosAlbum(original_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        }
        
        //获得编辑过的图片
        UIImage *image = [[info objectForKey: @"UIImagePickerControllerEditedImage"] copy];
        self.avatarView.image = image;
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSDictionary *parameters = @{
                                         @"avatar" : image,
                                         @"id": [UserManager manager].currentUser.uId
                                         };
            // 上传更新头像
            //            [[UserManager manager] avatarUpdateWithParameters:parameters];
            [[CJFTools manager] submitFormDataToUrl:APIUserUpdate withParameters:parameters exImgParameterName:@"avatar"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
    }
}


/**
 *  将图片保存到iPhone本地相册
 *  UIImage *image            图片对象
 *  id completionTarget       响应方法对象
 *  SEL completionSelector    方法
 *  void *contextInfo
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}



/**
 *  用户取消选择
 *
 *  @param picker 图片选择器对象
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
}

/**
 *  保存图片到本地
 */
-(void)saveAvartarToLocal: (UIButton *)sender {
    NSLog(@"save to phone album");
    UIImageWriteToSavedPhotosAlbum(self.avatarView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}






@end
