//
//  UIView+CJFUIView.m
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UIView+CJFUIView.h"

@implementation UIView (CJFUIView)

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
