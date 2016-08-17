//
//  UIImage+CJFImage.h
//  mySeedHabit
//
//  Created by cjf on 8/7/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CJFImage)

/**
 *  设置圆角图片
 *  此方法效率很高，并且能解决以下性能问题：
 *  1、通过cornerRadius和masksToBounds设置圆角，造成的卡顿
 *  2、通过xib&storyboard中设置layer的圆角属性，导致图层过量使用而造成卡顿，特别是设置阴影时的卡顿
 *
 *  @return UIImage对象
 */
-(UIImage *)circleImage;

-(UIImage *)circleImageWithRadius: (int)radius;


/**
 *  创建一个圆角图片
 *
 *  @param image 原始图片对象
 *  @param size  图片的size
 *  @param r     圆角半径
 *
 *  @return 图片对象
 */
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;


/**
 *  根据图片的二进制数据判断图片的类型（扩展类型）
 *
 *  @param data 二进制图片数据
 *
 *  @return 字符串：jpeg...
 */
+ (NSString *)typeForImageData:(NSData *)data;

@end
