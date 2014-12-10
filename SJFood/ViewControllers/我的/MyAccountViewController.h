//
//  MyAccountViewController.h
//  SJFood
//
//  Created by 叶帆 on 14/12/6.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "MineInfo.h"

@interface MyAccountViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *MyAccountTableView;

- (void)reloadWithUserInfo:(MineInfo *)baseMineInfo;

@end
