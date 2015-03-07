//
//  SpecView.m
//  SJFood
//
//  Created by 叶帆 on 14/12/24.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//

#import "SpecView.h"

@implementation SpecView
@synthesize screenImageView,specDetailView;
@synthesize iconImageView,foodTitleLabel,priceLabel,buyNumButton,restLabel;

#pragma mark - Public Methods
- (void)reloadWithFoodDetail:(FoodDetail *)foodDetail
{
    self.iconImageView.cacheDir = kUserIconCacheDir;
    [self.iconImageView aysnLoadImageWithUrl:foodDetail.imgUrl placeHolder:@"loading_square.png"];
    self.foodTitleLabel.text = foodDetail.name;
    if ([foodDetail.isDiscount isEqualToString:@"1"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.discountPrice floatValue]];
    }
    else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[foodDetail.price floatValue]];
    }
    self.restLabel.text = [NSString stringWithFormat:@"%@件",foodDetail.foodCount];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect progressFrame = CGRectMake(20, 30, ScreenWidth - 40, ScreenHeight - 60);
        self.screenImageView.frame = progressFrame;
    } completion:nil];
    [self bringSubviewToFront:specDetailView];
    [specDetailView addAnimationWithType:kCATransitionPush subtype:kCATransitionFromTop];
    
}

#pragma mark - IBAction Methods
- (IBAction)backButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSpecChooseNotification object:nil];
}

- (IBAction)addNumberButtonClicked:(id)sender {
}

- (IBAction)reduceNumberButtonClicked:(id)sender {
}

#pragma mark - UIView Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
