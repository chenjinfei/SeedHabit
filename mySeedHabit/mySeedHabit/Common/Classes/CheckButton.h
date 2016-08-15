//
//  CheckButton.h
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

typedef enum {
    CheckButtonStyleDefault = 0 ,
    CheckButtonStyleBox = 1 ,
    CheckButtonStyleRadio = 2
} CheckButtonStyle;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CheckButton : UIControl {
    //UIControl* control;
    UILabel * label ;
    UIImageView * icon ;
    BOOL checked ;
    id value , delegate ;
    CheckButtonStyle style ;
    NSString * checkname ,* uncheckname ; // 勾选／反选时的图片文件名
}
// 代理
@property ( retain , nonatomic ) id value,delegate;
// label
@property ( retain , nonatomic )UILabel* label;
// 图标
@property ( retain , nonatomic )UIImageView* icon;
// 风格：单选 or 多选
@property ( assign ) CheckButtonStyle style;

// 按钮风格的get方法
-( CheckButtonStyle )style;
// 按钮风格的set方法
-( void )setStyle:( CheckButtonStyle )st;

/**
 *  选中状态
 *
 *  @return YES or NO
 */
-( BOOL )isChecked;

/**
 *  设置选中状态
 *
 *  @param b YES or NO
 */
-( void )setChecked:( BOOL )b;

@end
