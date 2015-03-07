//
//  SpecView.h
//  SJFood
//
//  Created by 叶帆 on 14/12/24.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodDetail.h"

@interface SpecView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *screenImageView;
@property (strong, nonatomic) IBOutlet UIView *specDetailView;
@property (strong, nonatomic) IBOutlet YFAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyNumButton;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;

- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)addNumberButtonClicked:(id)sender;
- (IBAction)reduceNumberButtonClicked:(id)sender;

@end
