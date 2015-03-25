//
//  AddressListViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/3/26.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "Address.h"

@interface AddressListViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) Address *selectedAddress;
@property (strong, nonatomic) IBOutlet UITableView *addListTableView;

@end
