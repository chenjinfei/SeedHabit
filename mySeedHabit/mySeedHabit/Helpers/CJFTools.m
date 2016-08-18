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



/**
 *  提交form-data的数据(主要用于jpg图片的上传)
 *
 *  @param url        数据提交地址
 *  @param parameters 参数
 *  @param exImgName  图片的参数名(注意：这个参数对应的value值必须为UIImage对象)
 */
-(void)submitFormDataToUrl: (NSString *)url withParameters: (NSDictionary *)parameters exImgParameterName: (NSString *)exImgName {
    
    dispatch_queue_t queue = dispatch_queue_create("cjf.avatarUploadQueue", NULL);
    dispatch_async(queue, ^{
        
        //        NSString *url = APIUserUpdate;
        
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //根据url初始化request
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //要上传的图片
        UIImage *image=[parameters objectForKey:exImgName];
        //得到图片的data
        //    NSData* data = UIImagePNGRepresentation(image);
        NSData* data = UIImageJPEGRepresentation(image, 0.7);
        //http body的字符串
        NSMutableString *body = [[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [parameters allKeys];
        
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //如果key不是pic，说明value是字符类型，比如name：Boris
            if(![key isEqualToString:exImgName])
            {
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",MPboundary];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
            }
        }
        
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo.jpg\"\r\n", exImgName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        
        //建立连接，设置代理
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //设置接受response的data
        if (conn) {
            NSMutableData *mResponseData = [[NSMutableData data] init];
            NSLog(@"%@", mResponseData);
        }
        
    });
}




/**
 *  左右拼接图片
 *
 *  @param leftImage  左图
 *  @param rightImage 右图
 *
 *  @return 图片对象
 */
+(UIImage *)combineLeftImage: (UIImage *)leftImage andRightImage: (UIImage *)rightImage {
    CGFloat width = leftImage.size.width * 2;
    CGFloat height = leftImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, width/2, height);
    [leftImage drawInRect:rect];
    
    rect.origin.x += width/2;
    [rightImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

/**
 *  上下拼接图片
 *
 *  @param topImage    上图
 *  @param bottomImage 下图
 *
 *  @return 图片对象
 */
+(UIImage *)combineTopImage: (UIImage *)topImage andBottomImage: (UIImage *)bottomImage {
    
    CGFloat width = topImage.size.width;
    CGFloat height = topImage.size.height + bottomImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, width, topImage.size.height);
    [topImage drawInRect:rect];
    
    rect.origin.y += topImage.size.height;
    [bottomImage drawInRect:rect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

/**
 *  根据宽度计算字符串的高度
 *
 *  @param string 字符串
 *  @param width  宽度
 *  @param font   字体
 *
 *  @return CGFloat 高度
 */
+(CGFloat)heightWithString: (NSString *)string width: (CGFloat)width font: (UIFont *)font {
    NSLog(@"文本：%@, 宽度：%f", string, width);
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return textSize.height;
}




@end
