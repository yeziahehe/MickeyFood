//
//  SMS_SDK.h
//  SMS_SDKDemo
//
//  Created by 严军 on 14-8-28.
//  Copyright (c) 2014年 严军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMS_SDKResultHanderDef.h"
#import "SMS_UserInfo.h"
#import <MessageUI/MessageUI.h>

/**
 * @brief 短信SDK 顶层类(SMS SDK top class)
 */
@interface SMS_SDK : NSObject <MFMessageComposeViewControllerDelegate>

/**
 * @brief 注册应用，此方法在应用启动时调用一次并且只能在主线程调用(The registration application, this method is called during application startup time and only in the main thread calls)
 * @param appKey ,应用key,在shareSDK官网中注册的应用Key(Application of key, application of Key registered in the official website of shareSDK)
 * @param appSecret 应用秘钥，在shareSDK官网中注册的应用秘钥(Application of the secret key, secret key is registered in the application in shareSDK website)
 */
+(void)registerApp:(NSString*)appKey withSecret:(NSString*)appSecret;

/**
 * @brief 获取appkey(Access to appkey)
 * @return 返回appkey(Returns appkey)
 */
+(NSString*)appKey;

/**
 * @brief 获取appsecret(Access to appsecret)
 * @return 返回appsecret(Returns to appsecret)
 */
+(NSString*)appSecret;

/**
 * @brief 获取通讯录数据(Gets the mail list data)
 * @return 返回的数组里面存储的数据类型是SMS_AddressBook(The returned array inside the storage data type is SMS_AddressBook)
 */
+(NSMutableArray*)addressBook;

/**
 * @brief 发送短信(Send text messages)
 * @param 要发送短信的号码(Receive SMS mobile phone number)
 * @param 要发送的信息(Information to be transmitted)
 */
+(void)sendSMS:(NSString*)tel AndMessage:(NSString*)msg;


/**
 * @brief 向服务端请求获取通讯录好友信息(To obtain the mail list server request information friends)
 * @param 调用参数 默认填choose=1(The calling parameter default fill choose=1)
 * @param 请求结果回调block(Results the callback request block)
 */
+(void)getAppContactFriends:(int)choose
                     result:(GetAppContactFriendsBlock)result;

/**
 * @brief 获取验证码(Gets the verification code)
 * @param 电话号码(The phone number)
 * @param 区号(Area code)
 * @param 请求结果回调block(Results the callback request block)
 */
+(void)getVerifyCodeByPhoneNumber:(NSString*) phone
                          AndZone:(NSString*) zone
                           result:(GetVerifyCodeBlock)result;

/**
 * @brief 提交验证码(Submit the verification code)
 * @param 验证码(Verification code)
 * @param 请求结果回调block(Results the callback request block)
 */
+(void)commitVerifyCode:(NSString *)code
                 result:(CommitVerifyCodeBlock)result;

/**
 * @brief 请求所支持的区号(Request support code)
 * @param 请求结果回调block(Results the callback request block)
 */
+(void)getZone:(GetZoneBlock)result;

/**
 * @brief 提交用户资料(Submitted user data)
 * @param 用户信息(User information)
 * @param 请求结果回调block(Results the callback request block)
 */
+(void)submitUserInfo:(SMS_UserInfo*)user
               result:(SubmitUserInfoBlock)result;

/**
 * @brief 设置最近新好友条数(The most recent set of the number of new friends)
 * @param 好友条数(The number of friends)
 */
+(void)setLatelyFriendsCount:(int)count;

/**
 * @brief 显示最近新好友条数回调(Display recently new friends number callback)
 * @param 设置结果回调block(Results the callback request block)
 */
+(void)showFriendsBadge:(ShowNewFriendsCountBlock)result;

/**
 * @brief 是否启用通讯录好友功能(Whether to enable the mail list friend function)
 * @param YES 代表启用 NO 代表不启用 默认为启用(YES is enabled NO is not enabled Is enabled by default)
 */
+(void)enableAppContactFriends:(BOOL)state;

@end
