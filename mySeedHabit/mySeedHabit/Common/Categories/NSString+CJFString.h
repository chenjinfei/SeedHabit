//
//  NSString+CJFString.h
//  mySeedHabit
//
//  Created by cjf on 8/3/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CJFString)


/**
 *  MD5加密字符串
 *
 *  @param str 字符串对象
 *
 *  @return 可变字符串
 */
+(NSMutableString *)md5WithString: (NSString *)string;


/**
 *  MD5加密NSData数据
 *
 *  @param data NSData数据对象
 *
 *  @return 可变字符串
 */
+(NSMutableString *)md5WithData: (NSData *)data;


@end
