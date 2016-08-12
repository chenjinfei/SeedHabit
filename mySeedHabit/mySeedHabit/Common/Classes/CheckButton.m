//
//  CheckButton.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

@synthesize label,icon,value,delegate;

/**
 *  按钮的初始化方法
 *
 *  @param frame
 *
 *  @return 按钮对象
 */
-( id )initWithFrame:( CGRect ) frame
{
    if ( self =[ super initWithFrame : frame ]) {
        
        icon =[[ UIImageView alloc ]initWithFrame: CGRectMake (10, 0, frame.size.height, frame.size.height )];
        [self setStyle: CheckButtonStyleDefault]; // 默认风格为方框（多选）样式
        //self.backgroundColor=[UIColor grayColor];
        [self addSubview: icon ];
        
        label =[[UILabel alloc]initWithFrame: CGRectMake(icon.frame.size.width + 10, 0, frame.size.width - icon.frame.size.width - 20, frame.size.height )];
        label.backgroundColor =[ UIColor clearColor ];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =[UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentLeft;
        [ self addSubview: label];
        
        [ self addTarget: self action: @selector( clicked ) forControlEvents :UIControlEventTouchUpInside ];
        
    }
    return self ;
}

// 按钮风格的get方法
-( CheckButtonStyle )style{
    return style ;
}

// 按钮风格的set方法
-( void )setStyle:( CheckButtonStyle )st{
    style =st;
    switch ( style ) {
        case CheckButtonStyleDefault :
        case CheckButtonStyleBox :
            checkname = @"checkBox_selected.png" ;
            uncheckname = @"checkBox.png" ;
            break ;
        case CheckButtonStyleRadio :
            checkname = @"radio_selected.png" ;
            uncheckname = @"radio.png" ;
            break ;
        default :
            break ;
    }
    [ self setChecked : checked ];
}

/**
 *  选中状态
 *
 *  @return YES or NO
 */
-( BOOL )isChecked{
    return checked ;
}


/**
 *  设置选中状态
 *
 *  @param b YES or NO
 */
-( void )setChecked:( BOOL )b{
    if (b != checked ){
        checked = b;
    }
    if ( checked ) {
        [ icon setImage :[ UIImage imageNamed : checkname ]];
    } else {
        [ icon setImage :[ UIImage imageNamed : uncheckname ]];
    }
}

/**
 *  按钮的点击方法
 */
-( void )clicked {
    [ self setChecked: !checked ];
    if ( delegate != nil ) {
        // 将一个字符串方法转换成为SEL对象
        SEL sel= NSSelectorFromString ( @"checkButtonClicked:" );
        // 判断代理是否已实现方法
        if ([ delegate respondsToSelector :sel]){
            // 调用代理对象的sel方法
            [ delegate performSelector: sel withObject: self];
        } 
    }
}


@end
