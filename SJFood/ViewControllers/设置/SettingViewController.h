//
//  SettingViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong, nonatomic) IBOutlet UIView *logoutView;
@property (strong, nonatomic) IBOutlet UIView *messageView;

- (IBAction)logoutButtonClicked:(id)sender;

@end
