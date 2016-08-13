//
//  MindMotesModel.m
//  mySeedHabit
//
//  Created by cjf on 8/11/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MindNotesModel.h"

@implementation MindNotesModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _mId = (NSInteger)value;
    }
}

@end
