//
//  CJFTools.m
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFTools.h"

@implementation CJFTools

/**
 *  单例
 */
static CJFTools *instance = nil;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


/**
 *  时间戳转指定格式的时间
 *
 *  @param timestamp 时间戳 Exp: @"1368082020"
 *  @param format    时间格式 Exp: @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 字符串
 */
-(NSString *)revertTimeamp: (NSString *)timestamp withFormat: (NSString *)format {
    
    NSString *str = timestamp;//时间戳
    NSTimeInterval time=[str integerValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [formatter setDateFormat:format];
    
    NSString *currentDateStr = [formatter stringFromDate: detaildate];
    
    return currentDateStr;
}




@end
