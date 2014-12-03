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
            self.loginMember = [Member memberWithDict:dict];
            [[MemberDataManager sharedManager] saveLoginMemberData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginResponseNotification object:nil];
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
    else if ([downloader.purpose isEqualToString:kRegisterDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if ([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterResponseNotification object:nil];
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
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    NSLog(@"%@",message);
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
