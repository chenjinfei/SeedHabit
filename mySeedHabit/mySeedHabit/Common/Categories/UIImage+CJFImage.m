//
//  UIImage+CJFImage.m
//  mySeedHabit
//
//  Created by cjf on 8/7/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UIImage+CJFImage.h"

@implementation UIImage (CJFImage)

/**
 *  设置圆角图片
 *  此方法效率很高，并且能解决以下性能问题：
 *  1、通过cornerRadius和masksToBounds设置圆角，造成的卡顿
 *  2、通过xib&storyboard中设置layer的圆角属性，导致图层过量使用而造成卡顿，特别是设置阴影时的卡顿
 *
 *  @return UIImage对象
 */
-(UIImage *)circleImage {
    CGSize imageSize = self.size;
    //UIImage绘制为圆角
    int w = imageSize.width;
    int h = imageSize.height;
    int radius = imageSize.width/2;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}


-(UIImage *)circleImageWithRadius: (int)radius {
    CGSize imageSize = self.size;
    //UIImage绘制为圆角
    int w = imageSize.width;
    int h = imageSize.height;
    //    int radius = imageSize.width/2;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}



/**
 *  绘制圆角路径
 *
 *  @param context    图片上下文
 *  @param rect       路径
 *  @param ovalWidth  宽
 *  @param ovalHeight 高
 */
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

/**
 *  创建一个圆角图片
 *
 *  @param image 原始图片对象
 *  @param size  图片的size
 *  @param r     圆角半径
 *
 *  @return 图片对象
 */
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


/**
 *  根据图片的二进制数据判断图片的类型（扩展类型）
 *
 *  @param data 二进制图片数据
 *
 *  @return 字符串：jpeg...
 */
+ (NSString *)typeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            
        case 0x89:
            return @"image/png";
            
        case 0x47:
            return @"image/gif";
            
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
    
}

@end
