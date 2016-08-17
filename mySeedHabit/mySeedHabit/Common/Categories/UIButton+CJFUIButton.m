//
//  UIButton+CJFUIButton.m
//  mySeedHabit
//
//  Created by cjf on 8/13/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UIButton+CJFUIButton.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImage+CJFImage.h"
#import "UIView+WebCacheOperation.h"

@implementation UIButton (CJFUIButton)



/**
 *  结合SDWebImage设置按钮圆角图片
 *
 *  @param url              NSURL: 图片url
 *  @param placeHolderImage UIImage: 占位图对象
 *  @param radius           CGFloat: 圆角半径（这里必须保证图片为正方形图片）
 *  @param state            UIControlState: 按钮状态
 */
- (void)setImageWithUrl:(NSURL *)url placeHolderImage:(UIImage *)placeHolderImage radius:(CGFloat)radius forState: (UIControlState)state {
    
    dispatch_main_async_safe(^{
        if (radius != 0.0) {
            CGSize placeHolderSize = placeHolderImage.size;
            [self setImage:[placeHolderImage circleImageWithRadius:placeHolderSize.width/2] forState:state];
        }else {
            [self setImage:placeHolderImage forState:state];
        }
    });
    
    //取消正在下载的操作
    [self sd_cancelImageLoadForState:state];
    
    if (!url) {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (error) {
                NSLog(@"%@", error);
            }
        });
        return;
    }
    
    // 创建缓存key: cachedKey
    NSString *cachedKey = [NSString stringWithFormat:@"%@_myCachedKey%f", url, radius];
    // 从缓存中获取图片
    UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cachedKey];
    if (myCachedImage) {
        NSLog(@"有缓存图片");
        [self setImage:myCachedImage forState:state];
    }else {
        NSLog(@"没有缓存图片");
        __weak __typeof(self)wself = self;
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_async_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image && (SDWebImageLowPriority & SDWebImageAvoidAutoSetImage))
                {
                    NSLog(@"1");
                    return;
                }
                else if (image) {
                    NSLog(@"2");
                    [sself setImage:image forState:state];
                }
                if (finished) {
                    NSLog(@"3");
                    [[SDImageCache sharedImageCache] storeImage:[image circleImageWithRadius:radius] forKey:cachedKey];
                }
            });
        }];
    }
    
}





@end
