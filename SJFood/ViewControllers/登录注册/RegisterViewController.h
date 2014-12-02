//
//  RegisterViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/1.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonClicked:(id)sender;
@end
