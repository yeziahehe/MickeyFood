//
//  ResetPwdViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/3.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface ResetPwdViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *rePwdTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

- (IBAction)commitButtonClicked:(id)sender;


@end
