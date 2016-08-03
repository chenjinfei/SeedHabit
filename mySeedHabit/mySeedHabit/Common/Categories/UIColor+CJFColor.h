//
//  UIColor+CJFColor.h
//  mySeedHabit
//
//  Created by cjf on 8/2/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CJFColor)

/**
*  获取随机颜色
*
*  @param alpha 颜色透明度
*
*  @return UIColor对象
*/
+(UIColor *)randColorWithAlpha: (CGFloat)alpha;

/**
 *  获取16进制颜色值转换为RGB后的颜色
 *
 *  @param colorStr 16进制表示的颜色（0xc36000, 0xc36000, #c36000或者c36000格式都支持）
 *  @param alpha    颜色透明度
 *
 *  @return UIColor对象
 */
+(UIColor *)colorWithHexString: (NSString *)colorStr alpha: (CGFloat)alpha;

@end
