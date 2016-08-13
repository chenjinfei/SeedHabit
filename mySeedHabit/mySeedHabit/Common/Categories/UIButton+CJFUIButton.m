//
//  UIButton+CJFUIButton.m
//  mySeedHabit
//
//  Created by cjf on 8/13/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UIButton+CJFUIButton.h"

#import <UIImageView+WebCache.h>
#import "UIImage+CJFImage.h"

@implementation UIButton (CJFUIButton)

/**
 *  通过SDWebImage设置按钮圆角图片
 *
 *  @param url              NSURL: 图片url
 *  @param placeHolderImage UIImage: 占位图对象
 *  @param radius           CGFloat: 圆角半径
 *  @param state            UIControlState: 按钮状态
 *
 *  使用方法：
 *  NSURL *url = [NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=1994807006,3190709677&fm=58"];
 *  [testButton setImageWithUrl:url placeHolderImage:IMAGE(@"placeHolder.png") radius:50 forState:UIControlStateNormal];
 *  NSURL *url2 = [NSURL URLWithString:@"http://avatar.csdn.net/3/1/7/1_perfect_milk.jpg"];
 *  [testButton setImageWithUrl:url2 placeHolderImage:IMAGE(@"placeHolder.png") radius:50 forState:UIControlStateHighlighted];
 */
- (void)setImageWithUrl:(NSURL *)url placeHolderImage:(UIImage *)placeHolderImage radius:(CGFloat)radius forState: (UIControlState)state {
    
    __block UIImage *btnImage = nil;
    
    // 判断占位图是否存在, 设置默认占位图
    if (placeHolderImage == nil) {
        placeHolderImage = [[UIImage imageNamed:@"placeHolder.png"] circleImage];
    }
    
    /**
     *  这里进行手动缓存图片
     */
    NSString *cacheUrlStrKey = [[url absoluteString] stringByAppendingString:@"noRadiusCache"];
    // 先获取缓存图片
    UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheUrlStrKey];
    if (!cacheImg) {
        
        // 获取到网络图片
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *webImage = [UIImage imageWithData:imgData];
        
        if (webImage) {
            
            // 判断是否需要做图片的圆角处理
            if (radius != 0.0) {
                UIImage *radiusImage = [UIImage createRoundedRectImage:webImage size:self.frame.size radius:radius];
                btnImage = radiusImage;
            }else {
                btnImage = webImage;
            }
            
            // 进行图片缓存
            [[SDImageCache sharedImageCache] storeImage:btnImage forKey:cacheUrlStrKey];
            // 清除原有图片的缓存
            [[SDImageCache sharedImageCache] removeImageForKey:[url absoluteString]];
            
        }else {
            
            btnImage = placeHolderImage;
            
        }
        
    }else {
        btnImage = cacheImg;
    }
    
    [self setImage:btnImage forState:state];
    
    
}

@end
