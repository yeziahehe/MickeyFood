//
//  SendOrdersViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface SendOrdersViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *sendOrderTableView;
@property (strong, nonatomic) IBOutlet UIButton *notSelectButton;
@property (strong, nonatomic) IBOutlet UIButton *selectedButton;
@property (strong, nonatomic) IBOutlet UIView *noOrderView;

- (IBAction)notSelectButtonClicked:(id)sender;
- (IBAction)selectButtonClicked:(id)sender;


@end
