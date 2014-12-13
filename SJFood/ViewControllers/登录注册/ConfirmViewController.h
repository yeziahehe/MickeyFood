//
//  ConfirmViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/2.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *resendButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (strong, nonatomic) IBOutlet UITextField *identifyCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *agreeProtocolButton;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (IBAction)registerButtonClicked:(id)sender;
- (IBAction)resendButtonClicked:(id)sender;
- (IBAction)checkBoxButtonClicked:(id)sender;
- (IBAction)agreeProtocolButtonClicked:(id)sender;


@end
