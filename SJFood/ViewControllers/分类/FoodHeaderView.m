//
//  FoodHeaderView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodHeaderView.h"

@implementation FoodHeaderView
@synthesize iconImageView,foodTitleLabel,priceLabel,disCountLine,disCountPriceLabel,disCountLabel;

#pragma mark - Public Methods
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
{
    self.iconImageView.cacheDir = kUserIconCacheDir;
    [self.iconImageView aysnLoadImageWithUrl:foodDetail.imgUrl placeHolder:@"loading_square.png"];
    
    self.foodTitleLabel.text = foodDetail.name;
    if ([foodDetail.isDiscount isEqualToString:@"1"]) {
        self.disCountLabel.hidden = NO;
        self.disCountLine.hidden = NO;
        self.disCountPriceLabel.hidden = NO;
        self.disCountPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.price floatValue]];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.discountPrice floatValue]];
    }
    else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.price floatValue]];
    }
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
