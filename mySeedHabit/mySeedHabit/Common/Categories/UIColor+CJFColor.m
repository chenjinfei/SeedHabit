//
//  UIColor+CJFColor.m
//  mySeedHabit
//
//  Created by cjf on 8/2/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UIColor+CJFColor.h"

@implementation UIColor (CJFColor)

/**
 *  获取随机颜色
 *
 *  @param alpha 颜色透明度
 *
 *  @return UIColor对象
 */
+(UIColor *)randColorWithAlpha: (CGFloat)alpha; {
    CGFloat R = arc4random_uniform(256);
    CGFloat G = arc4random_uniform(256);
    CGFloat B = arc4random_uniform(256);
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:alpha];
}

/**
 *  获取16进制颜色值转换为RGB后的颜色
 *
 *  @param colorStr 16进制表示的颜色（0xc36000, 0xc36000, #c36000或者c36000格式都支持）
 *  @param alpha    颜色透明度
 *
 *  @return UIColor对象
 */
+(UIColor *)colorWithHexString: (NSString *)colorStr alpha: (CGFloat)alpha {
    // 移除前缀
    if ([colorStr hasPrefix:@"0x"] || [colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    // 判断长度
    if (colorStr.length != 6) {
        return [UIColor clearColor];
    }
    // 提取值
    NSRange range;
    range.length = 2;
    // R
    range.location = 0;
    NSString *rStr = [colorStr substringWithRange:range];
    // G
    range.location = 2;
    NSString *gStr = [colorStr substringWithRange:range];
    // B
    range.location = 4;
    NSString *bStr = [colorStr substringWithRange:range];
    // 转换值
    unsigned int R, G, B;
    // scanHexInt 扫描十六进制无符整型，unsigned int指针指向的地址值为 扫描到的值，包含溢出时的UINT_MAX
    [[NSScanner scannerWithString:rStr] scanHexInt:&R];
    [[NSScanner scannerWithString:gStr] scanHexInt:&G];
    [[NSScanner scannerWithString:bStr] scanHexInt:&B];
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:alpha];
}


@end
