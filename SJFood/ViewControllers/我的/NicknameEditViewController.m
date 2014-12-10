//
//  NicknameEditViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "NicknameEditViewController.h"

#define kUpdateNicknameDownloaderKey            @"UpdateNicknameDownloaderKey"

@interface NicknameEditViewController ()

@end

@implementation NicknameEditViewController
@synthesize nicknameTextField;
@synthesize nickname;

#pragma mark - Private methods
- (NSString *)checkFieldValid
{
    if(nicknameTextField.text.length <= 0)
        return @"请输入昵称";
    else
        return nil;
}

#pragma mark - IBAction Methods
- (IBAction)saveButtonClicked:(id)sender {
    [self.nicknameTextField resignFirstResponder];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:2.f];
    }
    else
    {
        //修改昵称
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUpdateNicknameUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phone"];
        [dict setObject:self.nicknameTextField.text forKey:@"nickname"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self
                                                                    purpose:kUpdateNicknameDownloaderKey];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"修改昵称"];
    self.nicknameTextField.text = nickname;
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nicknameTextField)
        [self saveButtonClicked:nil];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([downloader.purpose isEqualToString:kUpdateNicknameDownloaderKey])
    {
        NSDictionary *dict = [str JSONValue];
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoNotificaiton object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAccoutNotification object:nil];
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"修改昵称成功" hideDelay:2.f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if ([message isKindOfClass:[NSNull class]])
            {
                message = @"";
            }
            if(message.length == 0)
                message = @"修改昵称失败";
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    NSLog(@"%@",message);
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
