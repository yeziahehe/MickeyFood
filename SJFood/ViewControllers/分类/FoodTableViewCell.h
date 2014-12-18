//
//  FoodTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 14/12/18.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet YFAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *discountImage;
@property (strong, nonatomic) IBOutlet UIImageView *discountTagImage;

@end
