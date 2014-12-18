//
//  FoodTableViewCell.m
//  SJFood
//
//  Created by 叶帆 on 14/12/18.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodTableViewCell.h"

@implementation FoodTableViewCell
@synthesize iconImageView,foodTitleLabel,priceLabel,discountPriceLabel,saleNumLabel,discountImage,discountTagImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
