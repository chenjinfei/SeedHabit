//
//  UIButton+CJFUIButton.h
//  mySeedHabit
//
//  Created by cjf on 8/13/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CJFUIButton)

/**
 *  结合SDWebImage设置按钮圆角图片
 *
 *  @param url              NSURL: 图片url
 *  @param placeHolderImage UIImage: 占位图对象
 *  @param radius           CGFloat: 圆角半径（这里必须保证图片为正方形图片）
 *  @param state            UIControlState: 按钮状态
 */
- (void)setImageWithUrl:(NSURL *)url placeHolderImage:(UIImage *)placeHolderImage radius:(CGFloat)radius forState: (UIControlState)state;


@end
