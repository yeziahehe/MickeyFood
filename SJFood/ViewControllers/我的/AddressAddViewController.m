//
//  AddressAddViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/12.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AddressAddViewController.h"

#define kAddAddressDownloaderKey            @"AddAddressDownloaderKey"

@interface AddressAddViewController ()

@end

@implementation AddressAddViewController
@synthesize nameTextField,phoneTextField,schoolAreaTextField,addressTextField,contentView,contentScrollView;

#pragma mark - Private Methods
- (NSString *)checkFieldValid
{
    if(nameTextField.text.length < 1)
        return @"请输入收货人";
    else if(phoneTextField.text.length != 11)
        return @"请输入11位有效手机号码";
    else if (addressTextField.text.length < 1)
        return @"请输入收货地址";
    return nil;
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    //保存新建收货地址的操作
    [self resignAllField];
    
    NSString *checkString = [self checkFieldValid];
    if (checkString) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:checkString customView:nil hideDelay:2.f];
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kAddAddressUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.nameTextField.text forKey:@"name"];
        [dict setObject:self.phoneTextField.text forKey:@"phone"];
        [dict setObject:[NSString stringWithFormat:@"%@%@",self.schoolAreaTextField.text,self.addressTextField.text] forKey:@"address"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self purpose:kAddAddressDownloaderKey];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"新增收货地址"];
    [self setRightNaviItemWithTitle:@"保存" imageName:nil];
    [self.nameTextField becomeFirstResponder];
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, self.contentView.frame.origin.y + self.contentView.frame.size.height + 15.f)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark - Keyboard Notification methords
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, keyboardSize.height, self.contentScrollView.contentInset.right);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentScrollView.contentInset = UIEdgeInsetsMake(self.contentScrollView.contentInset.top, self.contentScrollView.contentInset.left, 0, self.contentScrollView.contentInset.right);
}

#pragma mark - UITextFieldDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameTextField)
    {
        [self.nameTextField resignFirstResponder];
        [self.phoneTextField becomeFirstResponder];
    }
    else if(textField == self.phoneTextField)
    {
        [self.phoneTextField resignFirstResponder];
        [self.addressTextField becomeFirstResponder];
    }
    else if(textField == self.addressTextField)
    {
        [self.addressTextField resignFirstResponder];
        [self rightItemTapped];
    }
    return YES;
}

#pragma mark - YFDownloaderDelegate Methods
- (void)downloader:(YFDownloader *)downloader completeWithNSData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    if ([downloader.purpose isEqualToString:kAddAddressDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAddressNotification object:nil];
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"添加成功" hideDelay:2.f];
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
                message = @"添加失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
