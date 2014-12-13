//
//  AddressEditViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/12.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "AddressEditViewController.h"

#define kDeleteAddressDownloaderKey             @"DeleteAddressDownloaderKey"
#define kUpdateAddressDownloaderKey             @"UpdateAddressDownloaderKey"

@interface AddressEditViewController ()

@end

@implementation AddressEditViewController
@synthesize nameTextField,phoneTextField,schoolAreaTextField,addressTextField,contentScrollView,deleteAddressButton;
@synthesize editAddress;

#pragma mark - Private Methods
- (void)loadSubViews
{
    [self.contentScrollView setContentSize:CGSizeMake(ScreenWidth, self.deleteAddressButton.frame.origin.y + self.deleteAddressButton.frame.size.height + 15.f)];
    self.nameTextField.text = editAddress.name;
    self.phoneTextField.text = editAddress.phone;
    self.addressTextField.text = [editAddress.address stringByReplacingOccurrencesOfString:self.schoolAreaTextField.text withString:@""];
    [self.nameTextField becomeFirstResponder];
}

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

#pragma mark - IBAction Methods
- (IBAction)deleteAddressButtonClicked:(id)sender
{
    //删除收货地址操作
    if ([self.editAddress.tag isEqualToString:@"0"]) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:@"该地址为默认地址，不可以删除" customView:nil hideDelay:2.f];
    } else {
        if (IsIos8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除收货地址"
                                                                           message:@"确定删除收货地址？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDeleteAddressUrl];
                                                        NSMutableDictionary *dict = kCommonParamsDict;
                                                        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
                                                        [dict setObject:self.editAddress.rank forKey:@"rank"];
                                                        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                                                                 postParams:dict
                                                                                                                contentType:@"application/x-www-form-urlencoded"
                                                                                                                   delegate:self purpose:kDeleteAddressDownloaderKey];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除收货地址" message:@"确定删除收货地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma mark - BaseViewController Methods
- (void)rightItemTapped
{
    //保存修改收货地址的操作
    [self resignAllField];
    
    NSString *checkString = [self checkFieldValid];
    if (checkString) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:checkString customView:nil hideDelay:2.f];
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUpdateAddressUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.nameTextField.text forKey:@"name"];
        [dict setObject:self.phoneTextField.text forKey:@"phone"];
        [dict setObject:[NSString stringWithFormat:@"%@%@",self.schoolAreaTextField.text,self.addressTextField.text] forKey:@"address"];
        [dict setObject:self.editAddress.rank forKey:@"rank"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self purpose:kUpdateAddressDownloaderKey];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"编辑收货地址"];
    [self setRightNaviItemWithTitle:@"保存" imageName:nil];
    [self loadSubViews];
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

#pragma mark - AlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kDeleteAddressUrl];
        NSMutableDictionary *dict = kCommonParamsDict;
        [dict setObject:[MemberDataManager sharedManager].loginMember.phone forKey:@"phoneId"];
        [dict setObject:self.editAddress.rank forKey:@"rank"];
        [[YFDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                                 postParams:dict
                                                                contentType:@"application/x-www-form-urlencoded"
                                                                   delegate:self purpose:kDeleteAddressDownloaderKey];
    }
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
    if ([downloader.purpose isEqualToString:kDeleteAddressDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAddressNotification object:nil];
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"删除成功" hideDelay:2.f];
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
                message = @"删除失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    else if ([downloader.purpose isEqualToString:kUpdateAddressDownloaderKey])
    {
        if([[dict objectForKey:kCodeKey] isEqualToString:kSuccessCode])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAddressNotification object:nil];
            [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"修改成功" hideDelay:2.f];
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
                message = @"修改失败";
            [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:message hideDelay:2.f];
        }
    }
    
}

- (void)downloader:(YFDownloader *)downloader didFinishWithError:(NSString *)message
{
    [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:kNetWorkErrorString hideDelay:2.f];
}

@end
