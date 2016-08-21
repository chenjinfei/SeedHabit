//
//  CJFDeserveUserModel.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFDeserveUserModel.h"

@implementation CJFDeserveUserModel

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uId = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
@implementation CJFDeserveHabit


-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _hId = (NSInteger)value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"mind_notes" : [CJFDeserveMindNotes class]};
}

@end


@implementation CJFDeserveMindNotes

@end


