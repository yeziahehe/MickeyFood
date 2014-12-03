//
//  UserInfo.h
//  SMS_SDKDemo
//
//  Created by admin on 14-6-19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief SMS_AddressBook类 为用户信息
 */

@interface SMS_UserInfo : NSObject

/**
 * @brief 用户头像地址
 */
@property(nonatomic,copy) NSString* avatar;

/**
 * @brief 用户id 用户自行定义
 */
@property(nonatomic,copy) NSString* uid;

/**
 * @brief 用户名
 */
@property(nonatomic,copy) NSString* nickname;

/**
 * @brief 电话
 */
@property(nonatomic,copy) NSString* phone;

@end
