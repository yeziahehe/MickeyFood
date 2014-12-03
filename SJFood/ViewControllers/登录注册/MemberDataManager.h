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

#define kLoginResponseNotification      @"LoginResponseNotification"
#define kRegisterResponseNotification   @"RegisterResponseNotification"

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
 *  缓存当前登录用户数据
 */
- (void)saveLoginMemberData;
/**
 *  用户登录
 *
 *  @param phone 用户名
 *  @param password 密码
 */
-(void)loginWithAccountName:(NSString *)phone password:(NSString *)password;
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


@end
