//
//  RadioGroup.h
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckButton;

@interface RadioGroup : NSObject {
    NSMutableArray * children ;
    NSString * text ;
    id value ;
}

@property ( readonly )NSString* text;
@property ( readonly ) id value;

-( void )add:( CheckButton *)cb;
-( void )checkButtonClicked:( id )sender;

@end


