//
//  CheckLogin.h
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeedUser;
@interface UserManager : NSObject

// 当前登录用户的信息
@property (nonatomic, strong) SeedUser *currentUser;

/**
 *  单例
 */
+(instancetype)manager;

/**
 *  检查是否已经登录
 *
 *  @return YES OR NO
 */
-(BOOL)checkLogin;

/**
 *  登录方法
 *
 *  @param info    登录用的参数
 *  @param success 登录成功的回调方法
 *  @param failure 登录失败的回调方法
 */
-(void)loginWithInfo:(NSDictionary *)info success: (void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  登出
 *
 *  @param success 登出成功的回调方法
 *  @param failure 登出失败的回调方法
 */
-(void)logoutSuccess: (void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure;

/**
 *  判断手机号是否已经注册
 *
 *  @param parameters       @{@"account":(NSNumber *)手机号码}
 *  @param responseBlock    回调方法
 */
-(void)isTelExists: (NSDictionary *)parameters responseBlock: (void(^)(id responseObject))responseBlock;

/**
 *  注册
 *
 *  @param parameters  用户注册信息
 *  @param success     注册成功的回调方法
 *  @param failure     注册失败的回调方法
 */
-(void)registerByParameters: (NSDictionary *)parameters success: (void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure;

/**
 *  设置本地登录持久化
 *
 *  @param username 用户名
 *  @param password 用户密码
 */
-(void)setUserDefaultsWithUserName: (NSString *)username password: (NSString *)password;

/**
 *  清除本地登录持久化数据
 */
-(void)removeUserDefaults;

@end
