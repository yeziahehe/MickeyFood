//
//  ShoppingCarTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 15/3/4.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"

@implementation ShoppingCarTableViewCell
@synthesize foodImageView,foodNameLabel,foodSpecalLabel,selectButton,priceLabel,numberLabel,discountPriceLabel,discountLine,editButton,minusButton,plusButton,numberTextField;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
