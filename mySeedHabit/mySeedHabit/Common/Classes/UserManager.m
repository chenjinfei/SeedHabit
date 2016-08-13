//
//  CheckLogin.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserManager.h"

#import "SeedUser.h"
#import <MJExtension.h>

#import "NSString+CJFString.h"

// 导入环信SDK
#import <EMSDK.h>

@interface UserManager ()<EMClientDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *session;

@end

@implementation UserManager

// 懒加载
-(AFHTTPSessionManager *)session {
    if (!_session) {
        _session = [AFHTTPSessionManager manager];
    }
    return _session;
}

-(NSNumber *)userId {
    if (!_userId) {
        _userId = [[NSNumber alloc]init];
    }
    return _userId;
}


// 获取当前登录用户
-(SeedUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [[SeedUser alloc]init];
    }
    if (_userId) {
        
        NSDictionary *parameters = @{@"user_id": _userId};
        [_session POST:APIUserInfo parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [_currentUser setValuesForKeysWithDictionary: responseObject[@"data"][@"user"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取用户信息失败：%@", error);
        }];
        
        return _currentUser;
        
    }else {
        return nil;
    }
}


/**
 *  单例
 */
static UserManager *instance = nil;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        // 添加环信平台的登录成功回调监听代理
        [[EMClient sharedClient] addDelegate:instance delegateQueue:nil];
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
 *  环信平台自动登录的回调方法：返回结果
 *
 *  @param aError 错误信息
 */
-(void)didAutoLoginWithError:(EMError *)aError {
    NSLog(@"%@", aError);
}


/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState {
    // 只需监听重连相关的回调，无需进行任何操作
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice {
    NSLog(@"当前登录账号在其它设备登录");
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer {
    NSLog(@"当前登录账号已经被从服务器端删除");
}


/**
 *  检查是否已经登录
 *
 *  @return YES OR NO
 */
-(BOOL)checkLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:USERNAME]) {
        NSLog(@"有持久化登录记录: \n userName: %@", [userDefaults valueForKey:USERNAME]);
        if ([userDefaults valueForKey:USERPASSWORD]) {
            NSLog(@"userPassword: %@", [userDefaults valueForKey:USERPASSWORD]);
        }
        return YES;
    }else {
        NSLog(@"未登录， 无持久化登录记录");
        return NO;
    }
}

/**
 *  登录方法
 *
 *  @param info    登录用的参数
 *  @param success 登录成功的回调方法
 *  @param failure 登录失败的回调方法
 */
-(void)loginWithInfo:(NSDictionary *)info success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    [self.session POST:APILogin parameters:info progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功登录，保存当前登录的用户信息
        if ([responseObject[@"status"] intValue] == 0) {
            SeedUser *model = [[SeedUser alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"][@"user"]];
            self.currentUser = model;
        }
        // 当为新用户是为用户进行环信的帐号注册
        // 否则再执行用户在环信的登录
        NSString *username = [NSString stringWithFormat:@"%@", [info valueForKey:@"account"]];
        NSString *password = nil;
        if ([info valueForKey:@"password"]) {
            password = [info valueForKey:@"password"];
        }else {
            password = [NSString md5WithString:@""];
        }
        EMError *error = nil;
        if ([responseObject[@"data"][@"new_user"] intValue]) {
            error = [[EMClient sharedClient] registerWithUsername:username password:password];
            if (error==nil) { // 注册成功
                success(responseObject);
            }
            NSString *username = [NSString stringWithFormat:@"%@", [info valueForKey:@"account"]];
            NSString *password = nil;
            if ([info valueForKey:@"password"]) {
                password = [info valueForKey:@"password"];
            }else {
                password = [NSString md5WithString:@""];
            }
            // 当为新用户是为用户进行环信的帐号注册
            // 否则再执行用户在环信的登录
            EMError *error = nil;
            if ([responseObject[@"data"][@"new_user"] intValue]) {
                error = [[EMClient sharedClient] registerWithUsername:username password:password];
                if (error==nil) { // 注册成功
                    success(responseObject);
                }
            }
            // 判断是否设置了环信的自动登录
            BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
            if (!isAutoLogin) {
                error = [[EMClient sharedClient] loginWithUsername:username password:password];
                if (!error) {
                    NSLog(@"登录环信成功");
                    // 开启环信自动登录，默认关闭
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }else {
                    NSLog(@"登录环信失败：%@", error);
                }
            }else {
                NSLog(@"开启了环信自动登录");
            }
            
            success(responseObject);
            
        }else {
            NSLog(@"用户登录失败：%@", responseObject[@"info"]);
            //            [self removeUserDefaults];
            success(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
//        NSLog(@"%@", error);
        
    }];
    
}

/**
 *  登出
 *
 *  @param success 登出成功的回调方法
 *  @param failure 登出失败的回调方法
 */
-(void)logoutSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    [self.session POST:APILogout parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 清除本地登录持久化数据
        [self removeUserDefaults];
        
        // 登出环信平台的登录
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出环信成功");
        }else {
            NSLog(@"退出环信失败");
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/**
 *  判断手机号是否已经注册
 *
 *  @param parameters       @{@"account":(NSNumber *)手机号码}
 *  @param responseBlock    回调方法
 */
-(void)isTelExists: (NSDictionary *)parameters responseBlock: (void(^)(id responseObject))responseBlock {
    
    [self.session POST:APIIsTelExist parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        responseBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        responseBlock(error);
    }];
}

/**
 *  注册
 *
 *  @param parameters  用户注册信息
 *  @param success     注册成功的回调方法
 *  @param failure     注册失败的回调方法
 */
-(void)registerByParameters: (NSDictionary *)parameters success: (void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure {
    [self.session POST:APIRegisterWithTel parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject[@"data"] != nil && [responseObject[@"status"] integerValue] == 0) {
            // 注册环信平台帐号
            NSString *username = [parameters valueForKey:@"account"];
            NSString *password = [parameters valueForKey:@"password"];
            EMError *error = [[EMClient sharedClient] registerWithUsername:username password:password];
            if (error==nil) { // 注册成功
                NSLog(@"注册环信平台帐号成功！");
            }
        }
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 *  设置本地登录持久化
 *
 *  @param username 用户名
 *  @param password 用户密码
 */
-(void)setUserDefaultsWithUserName: (NSString *)username password: (NSString *)password {
    
    [self removeUserDefaults];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (username) {
        [userDefaults setValue:username forKey:USERNAME];
    }
    if (password) {
        [userDefaults setValue:password forKey:USERPASSWORD];
    }
}

/**
 *  清除本地登录持久化数据
 */
-(void)removeUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USERNAME];
    [userDefaults removeObjectForKey:USERPASSWORD];
    
    NSDictionary* dict = [userDefaults dictionaryRepresentation];
    
    for(id key in dict) {
        
        [userDefaults removeObjectForKey:key];
        
    }
    
    [userDefaults synchronize];
    
    
    NSLog(@"清除本地持久化登录数据：username:%@, password:%@", [userDefaults valueForKey:USERNAME], [userDefaults valueForKey:USERPASSWORD])
}



/**
 *  更换头像
 *
 *  @param params 参数：@{@"avatar":<UIImage>, @"id", userId}
 */
-(void)avatarUpdateWithParameters:(NSDictionary *)params {
    
    NSString *url = APIUserUpdate;
    
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
    UIImage *image=[params objectForKey:@"avatar"];
    //得到图片的data
    //    NSData* data = UIImagePNGRepresentation(image);
    NSData* data = UIImageJPEGRepresentation(image, 0.7);
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"avatar"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"avatar\"; filename=\"photo.jpg\"\r\n"];
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
    
}


@end
