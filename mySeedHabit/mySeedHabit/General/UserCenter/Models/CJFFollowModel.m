//
//  CJFFollowModel.m
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFFollowModel.h"

@implementation CJFFollowModel

-(void)setValue:(id)value forKey:(NSString *)key {
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        _uId = value;
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
