//
//  CourierTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeStatusButton;
@property (strong, nonatomic) IBOutlet UITableView *orderDetailTableView;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (void)reloadData:(NSMutableArray *)orderDetail;

@end
