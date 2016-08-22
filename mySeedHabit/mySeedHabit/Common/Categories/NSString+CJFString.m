//
//  NSString+CJFString.m
//  mySeedHabit
//
//  Created by cjf on 8/3/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "NSString+CJFString.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CJFString)


/**
 *  MD5加密字符串
 *
 *  @param str 字符串对象
 *
 *  @return 可变字符串
 */
+(NSMutableString *)md5WithString: (NSString *)string {
    // 1、创建明文
    NSString *str = string;
    // 2、创建结果保存空间
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 3、加密
    const char *originStr = str.UTF8String;
    /**
     *  CC_MD5
     *
     *  @param originStr 明文内容（C语言）
     *  @param originStr 明文的长度
     *  @param result    密文保存空间
     *
     *  @return
     */
    CC_MD5(originStr, (CC_LONG)strlen(originStr), result);
    // 4、输出结果
    // 把128位的二进制转换成字符串，16进制的值
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        // "%02X"  代表2个十六进制数
        [resultStr appendFormat: @"%02X", result[i]];
    }
    return resultStr;
}


/**
 *  MD5加密NSData数据
 *
 *  @param data NSData数据对象
 *
 *  @return 可变字符串
 */
+(NSMutableString *)md5WithData: (NSData *)data {
    // 1、建立加密结构体
    CC_MD5_CTX ctx;
    // 2、初始化结构体
    CC_MD5_Init(&ctx);
    // 加载数据
    CC_MD5_Update(&ctx, data.bytes, (CC_LONG)data.length);
    // 加密
    unsigned char result[16];
    CC_MD5_Final(result, &ctx);
    // 输出结果
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [resultStr appendFormat:@"%02X", result[i]];
    }
    return resultStr;
}

/**
 *  是否为空验证
 *
 *  @param string 输入的内容
 *
 *  @return YES or NO
 */
+(BOOL)isValidateEmpty: (NSString *)string {
    return string.length == 0;
}


/**
 *  网址验证
 *
 *  @param url 网址
 *
 *  @return YES or NO
 */
-(BOOL)isValidateUrl: (NSString *)url {
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


/**
 *  邮箱验证
 *
 *  @param email 邮箱地址
 *
 *  @return YES or NO
 */
+(BOOL)isValidateEmail: (NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

/**
 *  手机号码验证
 *
 *  @param phoneNumber 手机号码
 *
 *  @return YES or NO
 */
+(BOOL)isValidatePhoneNumber: (NSString *)phoneNumber {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,181(增加)
     */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNumber]
         || [regextestcm evaluateWithObject:phoneNumber]
         || [regextestct evaluateWithObject:phoneNumber]
         || [regextestcu evaluateWithObject:phoneNumber])) {
        return YES;
    }
    
    return NO;
}

/**
 *  身份证号码验证
 *
 *  @param identityCard 身份证号码
 *
 *  @return YES or NO
 */
+(BOOL)isValidateIdentityCard: (NSString *)identityCard {
    if (identityCard.length <= 0) {
        return NO;
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


/**
 *  输入正则表达式 匹配 字符串
 *
 *  @param regExp 正则表达式
 *  @param string 字符串
 *
 *  @return YES or NO
 */
+(BOOL)validateWithRegExp: (NSString *)regExpx string: (NSString *)string {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExpx];
    return [predicate evaluateWithObject: string];
}


/**
 *  通过图片data数据的第一个字节来获取图片的扩展名
 *
 *  @param data 图片data数据
 *
 *  @return NSString格式的图片扩展名
 */
+(NSString *)contentTypeForImageData: (NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            break;
        case 0x89:
            return @"png";
            break;
        case 0x47:
            return @"gif";
            break;
        case 0x4D:
        case 0x49:
            return @"tiff";
            break;
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }else {
                NSString *testString = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return @"webp";
                }else {
                    return nil;
                }
            }
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}





//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    NSLog(@"%@, %ld", weekStr, components.weekday);
    return weekStr;
}

+ (NSInteger)getWeekDayForTimeamp:(long long)data
{
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    
    if (components.weekday != 1 ) {
        return components.weekday - 1;
    }else {
        return 7;
    }
}




@end
