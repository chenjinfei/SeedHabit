//
//  KeyboardObserved.h
//  键盘监听管理类
//  mySeedHabit
//
//  Created by cjf on 8/6/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardObserved : NSObject

// 键盘的frame
@property (nonatomic, assign) CGRect keyboardFrame;

/**
 *  单例
 */
+ (instancetype)manager;

/**
 *  键盘显示状态
 *
 *  @return 显示 or 隐藏
 */
-(BOOL)keyboardIsVisible;

/**
 *  设置键盘的可见值为显示
 */
-(void)keyboardWillShow: (NSNotification *)notification;

/**
 *  设置键盘的可见值为隐藏
 */
-(void)keyboardWillHide;

@end
