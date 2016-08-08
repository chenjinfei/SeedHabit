//
//  SeedUser.m
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "SeedUser.h"

@implementation SeedUser

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uId = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
