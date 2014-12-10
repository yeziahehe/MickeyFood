//
//  NicknameEditViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface NicknameEditViewController : BaseViewController

@property (nonatomic, strong) NSString *nickname;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;

- (IBAction)saveButtonClicked:(id)sender;
@end
