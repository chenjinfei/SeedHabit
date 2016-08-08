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
    if ([userDefaults valueForKey:@"userName"]) {
        return YES;
    }else {
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
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
        // 注册环信平台帐号
        NSString *username = [parameters valueForKey:@"account"];
        NSString *password = [parameters valueForKey:@"password"];
        EMError *error = [[EMClient sharedClient] registerWithUsername:username password:password];
        if (error==nil) { // 注册成功
            success(responseObject);
        }
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (username) {
        [userDefaults setValue:username forKey:@"userName"];
    }
    if (password) {
        [userDefaults setValue:password forKey:@"userPassword"];
    }
}

/**
 *  清除本地登录持久化数据
 */
-(void)removeUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"userPassword"];
}


@end
