//
//  PasswordEditViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface PasswordEditViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *theNewPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *rePasswordTextField;

- (IBAction)saveButtonClicked:(id)sender;
@end
