//
//  MemberDataManager.m
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "MemberDataManager.h"

@implementation MemberDataManager

@synthesize loginMember;

#pragma mark - Public Methods
- (BOOL)isLogin
{
    if(self.loginMember.phone.length > 0 && self.loginMember.password.length > 0)
        return YES;
    else
        return NO;
}

- (void)logout
{
    //清空用户信息
    self.loginMember.phone = nil;
    self.loginMember.password = nil;
    [self saveLoginMemberData];
    [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"退出成功" hideDelay:2.0f];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangeNotification object:nil];
}

- (void)loginWithAccountName:(NSString *)phone password:(NSString *)password
{
    if(nil == phone)
        phone = @"";
    if(nil == password)
        password = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kLoginUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:password forKey:@"password"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kLoginDownloaderKey];
}

- (void)checkUserExistWithPhone:(NSString *)phone
{
    if(nil == phone)
        phone = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kCheckUserExistUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kCheckUserExistDownloaderKey];
}

- (void)registerWithPhone:(NSString *)phone
                 password:(NSString *)password
                 nickName:(NSString *)nickName
{
    if (nil == phone)
        phone = @"";
    if (nil == password)
        password = @"";
    if (nil == nickName)
        nickName = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kRegisterUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:nickName forKey:@"nickname"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kRegisterDownloaderKey];
}

- (void)resetPwdWithPhone:(NSString *)phone newPassword:(NSString *)newPassword
{
    if (nil == phone)
        phone = @"";
    if (nil == newPassword)
        newPassword = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kResetPwdUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:newPassword forKey:@"newPassword"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kResetPwdDownloaderKey];
}

- (void)requestForUserInfo:(NSString *)phone
{
    if (nil == phone)
        phone = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUserInfoUrl];
    NSMutableDictionary *dict = kCommonParamsDict;
    [dict setObject:phone forKey:@"phone"];
    [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:dict
                                                            contentType:@"application/x-www-form-urlencoded"
                                                               delegate:self
                                                                purpose:kUserInfoDownloaderKey];
}

- (void)saveLoginMemberData
{
    //保存登录用户信息
    NSData *memberData = [NSKeyedArchiver archivedDataWithRootObject:self.loginMember];
    NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
    [memberData writeToFile:userDataFilePath atomically:NO];
}

#pragma mark - Singleton methods
- (id)init
{
    if(self = [super init])
    {
        //读取本地用户信息
        NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
        self.loginMember = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataFilePath];
        if(nil == loginMember)
            loginMember = [[Member alloc] init];
    }
    return self;
}

+ (MemberDataManager *)sharedManager
{
    static MemberDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MemberDataManager alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([downloader.purpose isEqualToString:kLoginDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            //self.loginMember = [Member memberWithDict:dict];
            [[MemberDataManager sharedManager] saveLoginMemberData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginResponseNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangeNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"登录失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginResponseNotification object:message];
        }
    }
    else if ([downloader.purpose isEqualToString:kCheckUserExistDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckUserExistResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"该手机号码已经注册";
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckUserExistResponseNotification object:message];
        }
    }
    else if ([downloader.purpose isEqualToString:kRegisterDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterResponseNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangeNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"注册失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterResponseNotification object:message];
        }
    }
    else if ([downloader.purpose isEqualToString:kResetPwdDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kResetPwdResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"重设密码失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:kResetPwdResponseNotification object:message];
        }
    }
    else if ([downloader.purpose isEqualToString:kUserInfoDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            self.mineInfo = [MineInfo mineInfoWithDict:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"个人信息获取失败";
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoResponseNotification object:message];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    NSLog(@"%@",message);
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
