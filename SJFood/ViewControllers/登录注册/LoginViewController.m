//
//  LoginViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/1.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameTextField,passwordTextField;

#pragma mark - Private methods
- (NSString *)checkFieldValid
{
    if(usernameTextField.text.length < 1)
        return @"请输入用户名";
    else if(passwordTextField.text.length < 1)
        return @"请输入密码";
    else
        return nil;
}

#pragma mark - IBAction Methods
- (IBAction)loginButtonClicked:(id)sender {
    [self resignAllField];
    
    NSString *checkString = [self checkFieldValid];
    if (checkString) {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:checkString customView:nil hideDelay:2.f];
    }
    else {
        [[YFProgressHUD sharedProgressHUD] startedNetWorkActivityWithText:@"登陆中..."];
        [[MemberDataManager sharedManager] loginWithAccountName:self.usernameTextField.text password:self.passwordTextField.text];
    }
}

- (IBAction)registerButtonClicked:(id)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (IBAction)forgetPasswordButtonClicked:(id)sender {
    ForgetPwdViewController *forgetPwdViewController = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPwdViewController animated:YES];
}

#pragma mark - Notification methods
- (void)loginRespnseWithNotification:(NSNotification *)notification
{
    if(notification.object)
    {
        //登录失败
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:notification.object hideDelay:2.f];
    }
    else
    {
        //登录成功
        [MemberDataManager sharedManager].loginMember.phone = self.usernameTextField.text;
        [MemberDataManager sharedManager].loginMember.password = self.passwordTextField.text;
        [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"登陆成功" hideDelay:2.f];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - BaseViewController methods
- (void)leftItemTapped
{
    [self resignAllField];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController Methods
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.usernameTextField.text = [MemberDataManager sharedManager].loginMember.phone;
    self.passwordTextField.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"登录"];
    [self setLeftNaviItemWithTitle:nil imageName:@"icon_header_cancel.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRespnseWithNotification:) name:kLoginResponseNotification object:nil];;
}

- (void)dealloc
{
    [[YFDownloaderManager sharedManager] cancelDownloaderWithDelegate:[MemberDataManager sharedManager] purpose:kLoginDownloaderKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if(textField == self.usernameTextField)
    {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField)
    {
        [self.passwordTextField resignFirstResponder];
        [self loginButtonClicked:nil];
    }
    return YES;
}

@end
