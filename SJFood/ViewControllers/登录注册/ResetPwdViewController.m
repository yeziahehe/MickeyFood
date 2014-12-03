//
//  ResetPwdViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "ResetPwdViewController.h"

@interface ResetPwdViewController ()

@end

@implementation ResetPwdViewController
@synthesize pwdTextField,rePwdTextField,commitButton;

#pragma mark - Private methods
- (NSString *)checkPasswordValid
{
    if(self.pwdTextField.text.length < 6 || self.rePwdTextField.text.length > 16)
        return @"请输入6-20位密码";
    else if(![self.pwdTextField.text isEqualToString:self.rePwdTextField.text])
        return @"两次密码不相同，请重新输入";
    else
        return nil;
}

#pragma mark - IBAction Methods
- (IBAction)commitButtonClicked:(id)sender {
    [self resignAllField];
    NSString *validString = [self checkPasswordValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:2.f];
    }
    else
    {
        // to do next action
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
    [self setNaviTitle:@"重设密码"];
    self.commitButton.enabled = NO;
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
    if (self.pwdTextField.text.length != 0 && self.rePwdTextField.text.length != 0) {
        self.commitButton.enabled = YES;
    }
    else{
        self.commitButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.pwdTextField)
        [self.rePwdTextField becomeFirstResponder];
    else if(textField == self.rePwdTextField)
        [self commitButtonClicked:nil];
    return YES;
}

@end
