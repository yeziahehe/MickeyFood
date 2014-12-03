//
//  ForgetPwdViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgetPwdViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *identifyCodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *resendButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)resendButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
