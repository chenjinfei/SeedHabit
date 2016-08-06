//
//  AppTools.m
//  UI_Dayeleven_Cell_autoHeight
//
//  Created by lanou on 16/6/3.
//  Copyright © 2016年 Lzhicong. All rights reserved.
//

#import "AppTools.h"

@implementation AppTools

+ (CGFloat)imageHeightWithImageName:(NSString *)imageName width:(CGFloat)width {

//    加载图片
    UIImage *image = [UIImage imageNamed:imageName];
    
//    获取图片大小
    CGSize imageSize = image.size;
    
//    通过大小计算对应的高度
    CGFloat height = 0.0;
    height = (imageSize.height * width) / imageSize.width;
    
    return height;
}

+ (CGFloat)heightWithString:(NSString *)str width:(CGFloat)width font:(UIFont *)font{

//    返回该字符串在指定情况下的空间大小
//    CGSize 以最小的为基准，计算最大者的
//    options 计算文本的基准， 第一个。。。
//    attributes 文本的属性，字典
//    context 保留 nil
//    return CGRect 结构体
    
//    高度大概有10pt的误差
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

@end
