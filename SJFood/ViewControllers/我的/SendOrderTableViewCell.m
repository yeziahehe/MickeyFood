//
//  SendOrderTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/27.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "SendOrderTableViewCell.h"

@implementation SendOrderTableViewCell
@synthesize togetherIdLabel,CourierNameLabel,orderDateLabel,totalPriceLabel,addressLabel,sendOrderButton;

- (void)awakeFromNib {
    // Initialization code
    self.sendOrderButton.layer.cornerRadius = 5.f;
    self.sendOrderButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
