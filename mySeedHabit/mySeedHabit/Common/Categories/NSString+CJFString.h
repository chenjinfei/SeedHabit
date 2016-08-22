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

/**
 *  是否为空验证
 *
 *  @param string 输入的内容
 *
 *  @return YES or NO
 */
+(BOOL)isValidateEmpty: (NSString *)string;

/**
 *  网址验证
 *
 *  @param url 网址
 *
 *  @return YES or NO
 */
-(BOOL)isValidateUrl: (NSString *)url;

/**
 *  邮箱验证
 *
 *  @param email 邮箱地址
 *
 *  @return YES or NO
 */
+(BOOL)isValidateEmail: (NSString *)email;

/**
 *  手机号码验证
 *
 *  @param phoneNumber 手机号码
 *
 *  @return YES or NO
 */
+(BOOL)isValidatePhoneNumber: (NSString *)phoneNumber;

/**
 *  身份证号码验证
 *
 *  @param identityCard 身份证号码
 *
 *  @return YES or NO
 */
+(BOOL)isValidateIdentityCard: (NSString *)identityCard;


/**
 *  输入正则表达式 匹配 字符串
 *
 *  @param regExp 正则表达式
 *  @param string 字符串
 *
 *  @return YES or NO
 */
+(BOOL)validateWithRegExp: (NSString *)regExpx string: (NSString *)string;

/**
 *  通过图片data数据的第一个字节来获取图片的扩展名
 *
 *  @param data 图片data数据
 *
 *  @return NSString格式的图片扩展名
 */
+(NSString *)contentTypeForImageData: (NSData *)data;




//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data;
+ (NSInteger)getWeekDayForTimeamp:(long long)data;

@end
