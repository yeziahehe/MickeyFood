//
//  FoodHeaderView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/21.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "FoodDetailSubView.h"

@interface FoodHeaderView : FoodDetailSubView
@property (strong, nonatomic) IBOutlet YFAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *disCountLine;
@property (strong, nonatomic) IBOutlet UILabel *disCountPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *disCountLabel;

@end
