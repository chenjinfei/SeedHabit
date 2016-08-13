//
//  RadioGroup.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "RadioGroup.h"

#import "CheckButton.h"

@implementation RadioGroup

@synthesize text,value;


-( id )init{
    if ( self =[ super init ]){
        children =[[ NSMutableArray alloc ] init ];
    }
    return self ;
}


-( void )add:( CheckButton *)cb{
    cb.delegate = self ;
    if ([cb isChecked] ) {
        text = cb.label.text;
        value = cb.value;
    }
    [children addObject: cb];
}


-( void )checkButtonClicked:( id )sender{
    CheckButton * cb=( CheckButton *)sender;
    // 实现单选
    for ( CheckButton * each in children ){
        if ( [each isChecked] ) {
            [each setChecked : NO ];
        }
    }
    if (![cb isChecked] ) {
        [cb setChecked : YES ];
        // 复制选择的项
        text = cb.label.text ;
        value = cb.value ;
    }else {
        
    }
    NSLog ( @"text:%@,value:%d" , text ,[( NSNumber *) value intValue ]);
}


@end
