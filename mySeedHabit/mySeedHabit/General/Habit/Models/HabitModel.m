//
//  HabitModel.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HabitModel.h"

#import "MindNotesModel.h"

@implementation HabitModel

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"private"]) {
        _iPrivate = value;
    }
    if ([key isEqualToString:@"id"]) {
        _hId = value;
    }
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"mind_notes" : [MindNotesModel class]};
}

@end



