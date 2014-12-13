//
//  FeedbackViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FeedbackViewController.h"

#define kFeedbackDownloaderKey      @"FeedbackDownloaderKey"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize feedbackTextView;

#pragma mark - Private methods
- (NSString *)checkFieldValid
{
    if(feedbackTextView.text.length < 1)
        return @"请输入您的宝贵意见";
    return nil;
}

#pragma mark - IBAction Methods
- (IBAction)commitFeedbackButtonClicked:(id)sender {
    [self.feedbackTextView resignFirstResponder];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:4.f];
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kFeedbackUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.feedbackTextView.text forKey:@"suggestion"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self purpose:kFeedbackDownloaderKey];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"意见反馈"];
    [self.feedbackTextView becomeFirstResponder];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - UITextViewDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllField];
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kFeedbackDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"提交成功" hideDelay:2.f];
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
                message = @"提交失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
