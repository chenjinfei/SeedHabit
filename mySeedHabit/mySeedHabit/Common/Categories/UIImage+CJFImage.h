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

@end
