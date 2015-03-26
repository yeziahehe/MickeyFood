//
//  OrderDetailTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/23.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell
@synthesize iconImageView,foodCountLabel,foodNameLabel,foodPriceLabel,foodSpecLabel,commentButton;

- (void)awakeFromNib {
    // Initialization code
    self.commentButton.layer.cornerRadius = 9.f;
    self.commentButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
