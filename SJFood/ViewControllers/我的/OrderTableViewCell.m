//
//  OrderTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/23.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell
@synthesize orderDetailTableView,orderDateLabel,orderStatusLabel,orderStatusChangeButton,orderDetailArray;

- (void)awakeFromNib {
    // Initialization code
    self.orderStatusChangeButton.layer.cornerRadius = 3.5f;
    self.orderStatusChangeButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
