//
//  PasswordEditViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "PasswordEditViewController.h"

@interface PasswordEditViewController ()

@end

@implementation PasswordEditViewController
@synthesize passwordTextField,theNewPasswordTextField,rePasswordTextField;

#pragma mark - Private methods
- (NSString *)checkPasswordValid
{
    if (![self.passwordTextField.text isEqualToString:[MemberDataManager sharedManager].loginMember.password])
        return @"旧密码输入不正确";
    else if(self.theNewPasswordTextField.text.length < 6 || self.theNewPasswordTextField.text.length > 16)
        return @"请输入6-20位新密码";
    else if(![self.theNewPasswordTextField.text isEqualToString:self.rePasswordTextField.text])
        return @"两次密码不相同，请重新输入";
    else
        return nil;
}

#pragma mark - IBAction Methods
- (IBAction)saveButtonClicked:(id)sender {
    [self resignAllField];
    NSString *validString = [self checkPasswordValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:2.f];
    }
    else
    {
        //重置密码
        [[MemberDataManager sharedManager] resetPwdWithPhone:[MemberDataManager sharedManager].loginMember.phone newPassword:self.theNewPasswordTextField.text];
    }
}

#pragma mark - Notification Methods
- (void)resetPwdResponseNotification:(NSNotification *)notification
{
    if(notification.object)
    {
        //重置密码失败
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:notification.object hideDelay:2.f];
    }
    else
    {
        //重置密码成功
        [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"重置密码成功" hideDelay:2.f];
        [MemberDataManager sharedManager].loginMember.password = self.theNewPasswordTextField.text;
        [[MemberDataManager sharedManager] saveLoginMemberData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"修改密码"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPwdResponseNotification:) name:kResetPwdResponseNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate methods
- (void)resignAllField
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField)
        [self.theNewPasswordTextField becomeFirstResponder];
    else if (textField == self.theNewPasswordTextField)
        [self.rePasswordTextField becomeFirstResponder];
    else if (textField == self.rePasswordTextField)
        [self saveButtonClicked:nil];
    return YES;
}

@end
