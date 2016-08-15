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
- (void)setImageWithUrl:(NSURL *)url placeHolderImage:(UIImage *)placeHolderImage radius:(CGFloat)radius forState: (UIControlState)state;


@end
