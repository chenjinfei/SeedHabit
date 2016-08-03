//
//  CheckLogin.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()

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
 *  检查是否已经登录
 *
 *  @return YES OR NO
 */
-(BOOL)checkLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"userName"] && [userDefaults valueForKey:@"userPassword"]) {
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
        
        // 本地持久化登录
        NSNumber *numName = [NSNumber numberWithInteger:[[info valueForKey:@"account"] integerValue]];
        NSString *password = [info valueForKey:@"password"];
        NSString *username = [NSString stringWithFormat:@"%@", numName];
        [self setUserDefaultsWithUserName:username password:password];
        
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:username forKey:@"userName"];
    [userDefaults setValue:password forKey:@"userPassword"];
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
