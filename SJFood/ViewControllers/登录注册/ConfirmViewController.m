//
//  ConfirmViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ConfirmViewController.h"

#define kResendTimeCount 60

@interface ConfirmViewController ()

@property (nonatomic, assign) NSInteger resendSecond;
@property (nonatomic, retain) NSTimer *resendTimer;

@end

@implementation ConfirmViewController
@synthesize registerButton,resendButton,checkBoxButton,agreeProtocolButton;
@synthesize identifyCodeTextField,nickNameTextField,passwordTextField,rePasswordTextField;
@synthesize resendSecond,resendTimer;

#pragma mark - Private Methods
- (NSString *)checkPasswordValid
{
    if(self.identifyCodeTextField.text.length == 0)
        return @"请输入验证码";
    else if(self.nickNameTextField.text.length == 0)
        return @"请输入昵称";
    else if(self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 20)
        return @"请输入6-20位密码";
    else if(![self.passwordTextField.text isEqualToString:self.rePasswordTextField.text])
        return @"两次密码不相同，请重新输入";
    else
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

- (void)initViewController
{
    //验证码计时器
    self.resendButton.enabled = NO;
    self.resendSecond = kResendTimeCount;
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
    
    self.checkBoxButton.selected = NO;
    self.registerButton.enabled = NO;
}

#pragma mark - IBAction Methods
- (IBAction)registerButtonClicked:(id)sender {
    [self resignAllFirstResponders];
    
    NSString *validPassword = [self checkPasswordValid];
    if(validPassword)
    {
        [[YFProgressHUD sharedProgressHUD]showWithMessage:validPassword customView:nil hideDelay:4.f];
    }
    else
    {
        // to do register action
    }
}

- (IBAction)resendButtonClicked:(id)sender {
    [self resignAllFirstResponders];
    
    self.resendButton.enabled = NO;
    self.resendSecond = kResendTimeCount;
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
}

- (IBAction)checkBoxButtonClicked:(id)sender {
    self.checkBoxButton.selected = !self.checkBoxButton.selected;
    if(checkBoxButton.selected)
    {
        self.registerButton.enabled = YES;
    }
    else
    {
        self.registerButton.enabled = NO;
    }
}

- (IBAction)agreeProtocolButtonClicked:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Mickeyabout" ofType:@"html"];
    YFWebViewController *yfwvc = [[YFWebViewController alloc] init];
    yfwvc.htmlTitle = @"服务条款";
    yfwvc.htmlPath = path;
    [self.navigationController pushViewController:yfwvc animated:YES];
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"注册"];
    [self initViewController];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.identifyCodeTextField)
        [self.nickNameTextField becomeFirstResponder];
    else if(textField == self.nickNameTextField)
        [self.passwordTextField becomeFirstResponder];
    else if(textField == self.passwordTextField)
        [self.rePasswordTextField becomeFirstResponder];
    else if(textField == self.rePasswordTextField)
        [self registerButtonClicked:nil];

    return YES;
}

- (void)resignAllFirstResponders
{
    [self.view endEditing:YES];
}

@end
