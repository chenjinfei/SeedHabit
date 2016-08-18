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



/**
 *  提交form-data的数据(主要用于jpg图片的上传)
 *
 *  @param url        数据提交地址
 *  @param parameters 参数
 *  @param exImgName  图片的参数名(注意：这个参数对应的value值必须为UIImage对象)
 */
-(void)submitFormDataToUrl: (NSString *)url withParameters: (NSDictionary *)parameters exImgParameterName: (NSString *)exImgName;


/**
 *  左右拼接图片
 *
 *  @param leftImage  左图
 *  @param rightImage 右图
 *
 *  @return 图片对象
 */
+(UIImage *)combineLeftImage: (UIImage *)leftImage andRightImage: (UIImage *)rightImage;



/**
 *  上下拼接图片
 *
 *  @param topImage    上图
 *  @param bottomImage 下图
 *
 *  @return 图片对象
 */
+(UIImage *)combineTopImage: (UIImage *)topImage andBottomImage: (UIImage *)bottomImage;


/**
 *  根据宽度计算字符串的高度
 *
 *  @param string 字符串
 *  @param width  宽度
 *  @param font   字体
 *
 *  @return CGFloat 高度
 */
+(CGFloat)heightWithString: (NSString *)string width: (CGFloat)width font: (UIFont *)font;

@end
