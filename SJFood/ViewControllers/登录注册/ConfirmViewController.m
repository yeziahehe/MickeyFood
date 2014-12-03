//
//  ConfirmViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ConfirmViewController.h"
#import "SMS_SDK/SMS_SDK.h"
#import "SMS_SDK/CountryAndAreaCode.h"

#define kResendTimeCount 60

@interface ConfirmViewController ()

@property (nonatomic, assign) NSInteger resendSecond;
@property (nonatomic, retain) NSTimer *resendTimer;

@end

@implementation ConfirmViewController
@synthesize registerButton,resendButton,checkBoxButton,agreeProtocolButton;
@synthesize identifyCodeTextField,nickNameTextField,passwordTextField,rePasswordTextField,phoneLabel;
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

- (NSMutableAttributedString *)codeStatusLabel:(NSString *)status
{
    NSString *phoneString = [NSString stringWithFormat:status,[MemberDataManager sharedManager].loginMember.phone];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:phoneString];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.f/255 green:124.f/255 blue:106.f/255 alpha:1.f] range:NSMakeRange(6, [MemberDataManager sharedManager].loginMember.phone.length)];
    return attriString;
}

- (void)getVerifyCode
{
    //验证码获取
    [SMS_SDK getVerifyCodeByPhoneNumber:[MemberDataManager sharedManager].loginMember.phone AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1 == state) {
            self.phoneLabel.attributedText = [self codeStatusLabel:@"验证码已发往%@，请稍等"];
            //to do 成功操作
        }
        else if (0 == state) {
            self.phoneLabel.text = @"验证码发送失败，请稍后重试";
            [[YFProgressHUD sharedProgressHUD]showFailureViewWithMessage:@"验证码发送失败，请稍后重试" hideDelay:2.f];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            self.phoneLabel.text = @"请求验证码超上限，请稍后重试";
            [[YFProgressHUD sharedProgressHUD]showFailureViewWithMessage:@"请求验证码超上限，请稍后重试" hideDelay:2.f];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            self.phoneLabel.text = @"客户端请求发送短信验证过于频繁";
            [[YFProgressHUD sharedProgressHUD]showFailureViewWithMessage:@"客户端请求发送短信验证过于频繁" hideDelay:2.f];
        }
    }];
}

- (void)initViewController
{
    //验证码计时器
    self.resendButton.enabled = NO;
    self.resendSecond = kResendTimeCount;
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
    
    self.checkBoxButton.selected = NO;
    self.registerButton.enabled = NO;
    
    self.phoneLabel.text = @"验证码正在发送中，请稍等";
    [self getVerifyCode];
}

#pragma mark - IBAction Methods
- (IBAction)registerButtonClicked:(id)sender {
    [self resignAllFirstResponders];
    
    NSString *validPassword = [self checkPasswordValid];
    if(validPassword)
    {
        [[YFProgressHUD sharedProgressHUD]showWithMessage:validPassword customView:nil hideDelay:2.f];
    }
    else
    {
        //提交验证码
        [SMS_SDK commitVerifyCode:self.identifyCodeTextField.text result:^(enum SMS_ResponseState state) {
            if (1 == state) {
                //验证成功后的注册操作
                [MemberDataManager sharedManager].loginMember.password = self.passwordTextField.text;
                [[YFProgressHUD sharedProgressHUD] startedNetWorkActivityWithText:@"注册中..."];
                [[MemberDataManager sharedManager] registerWithPhone:[MemberDataManager sharedManager].loginMember.phone
                                                            password:[MemberDataManager sharedManager].loginMember.password
                                                            nickName:self.nickNameTextField.text];
            }
            else if(0 == state)
            {
                [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:@"验证码填写错误" hideDelay:2.f];
            }
        }];
    }
}

- (IBAction)resendButtonClicked:(id)sender {
    [self resignAllFirstResponders];
    
    self.resendButton.enabled = NO;
    self.resendSecond = kResendTimeCount;
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(resendTimerChange) userInfo:nil repeats:YES];
    self.phoneLabel.text = @"验证码正在发送中，请稍等";
    [self getVerifyCode];
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

#pragma mark - Notification Methods
- (void)registerResponseWithNotification:(NSNotification *)notification
{
    if(notification.object)
    {
        //注册失败
        [[YFProgressHUD sharedProgressHUD] showFailureViewWithMessage:notification.object hideDelay:2.f];
    }
    else
    {
        //注册成功
        [[YFProgressHUD sharedProgressHUD] showSuccessViewWithMessage:@"您已注册成功，正在自动登录" hideDelay:2.f];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"注册"];
    [self initViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerResponseWithNotification:) name:kRegisterResponseNotification object:nil];
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
