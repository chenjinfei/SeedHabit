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


@end
