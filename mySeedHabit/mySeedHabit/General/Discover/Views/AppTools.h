//
//  AppTools.h
//  UI_Dayeleven_Cell_autoHeight
//
//  Created by lanou on 16/6/3.
//  Copyright © 2016年 Lzhicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppTools : NSObject

//获取指定图片，在指定宽度下，对应的高度
+ (CGFloat)imageHeightWithImage:(UIImage *)image width:(CGFloat)width;

//获取指定宽度和字体情况下，文本的高度
+ (CGFloat)heightWithString:(NSString *)str width:(CGFloat)width font:(UIFont *)font;

@end
