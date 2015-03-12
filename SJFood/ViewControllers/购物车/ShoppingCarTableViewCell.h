//
//  ShoppingCarTableViewCell.h
//  SJFood
//
//  Created by 叶帆 on 15/3/4.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) IBOutlet YFAsynImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodSpecalLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *discountLine;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmNumButton;
@property (strong, nonatomic) IBOutlet UILabel *countStatusLabel;


@end
