//
//  OrderTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/23.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderStatusChangeButton;
@property (strong, nonatomic) NSMutableArray *orderDetailArray;

@end
