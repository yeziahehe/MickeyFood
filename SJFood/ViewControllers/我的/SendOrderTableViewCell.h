//
//  SendOrderTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *togetherIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *CourierNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendOrderButton;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
