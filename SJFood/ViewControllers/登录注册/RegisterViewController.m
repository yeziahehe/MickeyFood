//
//  RegisterViewController.m
//  SJFood
//
//  Created by 叶帆 on 14/12/1.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "RegisterViewController.h"
#import "ConfirmViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize nextButton,phoneNumTextField;

#pragma mark - Private methods
- (NSString *)checkFieldValid
{
    //手机号长度11-11 手机号验证
    if(phoneNumTextField.text.length != 11)
        return @"请输入11位有效的手机号码";
    else
        return nil;
}

#pragma mark - IBAction Methods
- (IBAction)nextButtonClicked:(id)sender {
    [self.phoneNumTextField resignFirstResponder];
    NSString *validString = [self checkFieldValid];
    if(validString)
    {
        [[YFProgressHUD sharedProgressHUD] showWithMessage:validString customView:nil hideDelay:4.f];
    }
    else
    {
        // to do next action
        ConfirmViewController *confirmViewController = [[ConfirmViewController alloc]initWithNibName:@"ConfirmViewController" bundle:nil];
        [self.navigationController pushViewController:confirmViewController animated:YES];
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
    [self setNaviTitle:@"注册"];
    self.nextButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldChange:(NSNotification *)notification
{
    if (self.phoneNumTextField.text.length != 0) {
        self.nextButton.enabled = YES;
    }
    else{
        self.nextButton.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
