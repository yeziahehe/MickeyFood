//
//  MemberDataManager.h
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Member.h"

#define kLoginDownloaderKey             @"LoginDownloaderKey"
#define kRegisterDownloaderKey          @"RegisterDownloaderKey"
#define kCheckUserExistDownloaderKey    @"CheckUserExistDownloaderKey"
#define kResetPwdDownloaderKey          @"ResetPwdDownloaderKey"

#define kLoginResponseNotification              @"LoginResponseNotification"
#define kRegisterResponseNotification           @"RegisterResponseNotification"
#define kCheckUserExistResponseNotification     @"CheckUserExistResponseNotification"
#define kResetPwdResponseNotification           @"ResetPwdResponseNotification"

/**
 *  该类用于管理注册登录模块的数据处理
 */

@interface MemberDataManager : NSObject

@property (nonatomic, strong) Member *loginMember;

+ (MemberDataManager *)sharedManager;
/**
 *  判断用户是否登录
 *
 *  @return YES-已经登录  NO-未登录
 */
- (BOOL)isLogin;
/**
 *  退出登录
 */
- (void)logout;
/**
 *  缓存当前登录用户数据
 */
- (void)saveLoginMemberData;
/**
 *  用户登录
 *
 *  @param phone    用户名
 *  @param password 密码
 */
- (void)loginWithAccountName:(NSString *)phone password:(NSString *)password;
/**
 *  校验手机号是否存在
 *
 *  @param phone 手机号
 */
- (void)checkUserExistWithPhone:(NSString *)phone;
/**
 *  用户注册
 *
 *  @param phone       手机号
 *  @param password    密码
 *  @param nickName    昵称
 */
- (void)registerWithPhone:(NSString *)phone
                 password:(NSString *)password
                 nickName:(NSString *)nickName;
/**
 * 通过手机号找回密码
 *
 * @param phone       手机号
 * @param newPassword 新密码
 */
- (void)resetPwdWithPhone:(NSString *)phone newPassword:(NSString *)newPassword;

@end
