//
//  KeyboardObserved.m
//  mySeedHabit
//
//  Created by cjf on 8/6/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "KeyboardObserved.h"

@interface KeyboardObserved ()

// 是否显示
@property (nonatomic, assign) BOOL keyboardIsVisible;

@end

@implementation KeyboardObserved

/**
 *  单例
 */
static KeyboardObserved *instance = nil;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:instance selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:instance selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        instance.keyboardIsVisible = NO;
    });
    return instance;
}
+ (instancetype)allocWithZone: (struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

/**
 *  键盘将要显示，设置键盘的可见值为显示
 */
-(void)keyboardWillShow: (NSNotification *)notification {
    _keyboardIsVisible = YES;
    [self keyboardHeight:notification];
}

/**
 *  键盘将要隐藏，设置键盘的可见值为隐藏
 */
-(void)keyboardWillHide: (NSNotification *)notification {
    _keyboardIsVisible = NO;
}

/**
 *  键盘的显示状态
 *
 *  @return YES or NO
 */
-(BOOL)keyboardIsVisible {
    return _keyboardIsVisible;
}

/**
 *  保存键盘的高度
 *
 *  @param notification 通知对象
 */
-(void)keyboardHeight: (NSNotification *)notification {
    //键盘frame
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = keyBoardFrame;
}







@end
