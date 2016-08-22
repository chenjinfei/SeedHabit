//
//  CJFNoteModel.m
//  mySeedHabit
//
//  Created by cjf on 8/19/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFNoteModel.h"

@implementation CJFNoteModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
@implementation CJFNoteCtnModel

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uId = (NSInteger)value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation CJFHabitModel

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uId = (NSInteger)value;
    }
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation CJFUserModel

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uId = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


