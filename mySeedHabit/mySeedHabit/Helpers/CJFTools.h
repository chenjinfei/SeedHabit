//
//  CJFTools.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFTools : NSObject

/**
 *  单例
 */
+ (instancetype)manager;


/**
 *  时间戳转指定格式的时间
 *
 *  @param timestamp 时间戳 Exp: @"1368082020"
 *  @param format    时间格式 Exp: @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 字符串
 */
-(NSString *)revertTimeamp: (NSString *)time withFormat: (NSString *)format;

@end