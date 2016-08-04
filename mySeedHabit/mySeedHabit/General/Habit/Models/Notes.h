//
//  Notes.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/3.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;
@interface Notes : NSObject

@property (nonatomic, strong) NSArray *props;

@property (nonatomic, assign) NSInteger check_in_times;

@property (nonatomic, strong) Note *note;

@property (nonatomic, strong) NSArray *comments;

@end



