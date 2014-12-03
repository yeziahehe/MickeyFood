//
//  ForgetPwdViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ResetPwdViewController.h"

#define kResendTimeCount 60

@interface ForgetPwdViewController ()

@property (nonatomic, assign) NSInteger resendSecond;
@property (nonatomic, retain) NSTimer *resendTimer;

@end

@implementation ForgetPwdViewController
@synthesize phoneTextField,identifyCodeTextField,resendButton,nextButton;
@synthesize resendSecond,resendTimer;

#pragma mark - Private Methods
- (NSString *)checkFieldValid
{
    if(self.phoneTextField.text.length != 11)
        return @"请输入11位有效的手机号码";
    return nil;
}

- (void)resendTimerChange
{
    self.resendSecond--;
    [self.resendButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.resendSecond] forState:UIControlStateDisabled];
    if(self.resendSecond <= 0)
    {
        [self.resendButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.resendButton setTitle:@"重新获取" forState:UIControlStateDisabled];
        self.resendButton.enabled = YES;
        [self.resendTimer invalidate];
        self.resendTimer = nil;
    }
}

#pragma mark - IBAction Methods
- (IBAction)resendButtonClicked:(id)sender {
    [self resignAllField];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:2.f];
    }
    else
    {
        //to do 获取验证码
        self.resendButton.enabled = NO;
        self.resendSecond = kResendTimeCount;
        self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    [self resignAllField];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:2.f];
    }
    else
    {
        // to do next action
        ResetPwdViewController *resetPwdViewController = [[ResetPwdViewController alloc]initWithNibName:@"ResetPwdViewController" bundle:nil];
        [self.navigationController pushViewController:resetPwdViewController animated:YES];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"找回密码"];
    self.nextButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
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

- (void)textFieldChange:(NSNotification *)notification
{
    if (self.phoneTextField.text.length != 0 && self.identifyCodeTextField.text.length != 0) {
        self.nextButton.enabled = YES;
    }
    else{
        self.nextButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.phoneTextField)
    {
        [self.identifyCodeTextField becomeFirstResponder];
    }
    else if(textField == self.identifyCodeTextField)
    {
        [self nextButtonClicked:nil];
    }
    return YES;
}

@end
